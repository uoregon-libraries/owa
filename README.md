# OWA Container

This project aims to set up a useful OWA service for UO.

## Development Setup

1. Copy `docker-compose.override.yml-example` to `docker-compose.override.yml`
   and alter it as needed; this is where you specify on which port OWA is
   listening, add volume mounts if desired, and do anything else that's
   specific to your environment.
2. Copy `env-example` to `.env` in order to set up the OWA database password,
   choose random values for the keys and salts the application uses, and set
   the public URL.
   - **Whenever you change the port in your docker compose override, you need
     to change the "public URL" in `.env`**
3. If desired, copy `docker/owa.sql` into `docker/mysql-init` to skip some of
   the web-wizard setup.  This will create the database structure as well as
   install an administrative user.  You will be able to log in as "adm" with
   the password "adm".  You **must** change this for production.
4. The project states it cannot be used from localhost or a raw IP address.
   This makes testing a pain.  You'll want to stand this up on a server that
   has a hostname if you want to do any kind of testing.

If for some reason you override the db name or user in the `db` container, make
sure you apply the same override(s) to the `web` container.

**WARNING**: Do *not* use `owa.sql` in a production environment.  The user
cannot be deleted and presents not only an annoyance, but a security risk.  *DO
NOT complete these development steps for a production install.*

## Production Setup

Read these steps.  These are not the same as development steps.  Do not start
anything on production until you've read these steps.  Don't skip steps or
alter the steps unless you are **100% certain that you know the consequences of
doing so.**

1. Copy `docker-compose.override.yml-example` to `docker-compose.override.yml`
   and alter it to specify the port you wish the OWA container to use.
   - You should **not** mount any local files into the running containers in
     production, as this makes the application less scalable and in some cases
     less secure.
2. Copy `env-example` to `.env` in order to set up the OWA database password,
   choose random values for the keys and salts the application uses, and set
   the public URL.
   - **All "changeme" values must be set to secure random strings.**
3. Visit the site at the public URL and fill in the initial data and admin
   user.  Make sure the default admin user's name is *not* "adm" or "admin" or
   anything else obvious.  Choose a random, secure password.
4. Enable the server for public access.  Do not do this before step 3.  You do
   not want somebody accidentally hitting the setup pages and hijacking the
   server, even if it's nothing more than a minor annoyance.
5. Stop the containers, remove them (`docker-compose down` will do this), and
   then restart them.
   - `/var/www/html/install.php` is not part of our docker image - the setup
     scripts only copy it there if it's needed.  Container removal kills that
     file and then the next time you start the server, it won't be copied in
     again since the setup has been completed.
   - Without this magic, anybody can do all kinds of awful stuff:
     https://github.com/Open-Web-Analytics/Open-Web-Analytics/issues/735

An easy way to generate random text for passwords/keys/salts:

```bash
cat /dev/urandom | tr -dc 'a-zA-Z0-9_-' | fold -w 30 | head -n 1
```

Change the allowed `tr` list as needed, change the fold width as needed, change
the `head` number to generate more passwords at once, etc.

## Tracking Codes

So here's a fun thing: the tracking code JS snippet provided by OWA... doesn't
actually work all the time.  One problem is that `owa.tracker-combined-min.js`
is explicitly blocked by some ad blockers.  We could potentially rename it to
try and get around that, because this is (a) not ad-related, and (b) something
we're using to *improve* privacy while still figuring out how our sites are
used.

But beyond that, something in certain plugins can actually *silently* prevent
the JS from pulling in `log.php`.  I still haven't tracked this down.  With
tracking protection off, and uBlock disabled, I get the JS but not the requests
to `log.php`.  I only managed to get this to work by using a completely
plugin-free Firefox.

But here's what's weird: if you use the "traditional" style of JS injection, it
works.  I do not know why.  The new, recommended "async" method doesn't work.
Both methods pull down the JS just fine, but only the "traditional" method gets
events sent to `log.php`.

Unfortunately OWA doesn't give you the option to choose the traditional
snippet.  It only shows you the async snippet, so if we want the traditional
snippet, we have to build it manually.  And the example in their wiki... is
broken.

So this is what we could choose to use if we're okay with monkeying around with
the code each time, rather than having a nice copy-paste approach:

```html
<script src='https://<OWA Hostname>/modules/base/js/owa.tracker-combined-min.js'
        type='text/javascript'></script>

<script type="text/javascript">
//<![CDATA[
try {
  OWA.setSetting('baseUrl',  "https://<OWA Hostname>/");
  OWATracker = new OWA.tracker();
  OWATracker.setSiteId('<OWA Site ID>');
  OWATracker.trackPageView();
  OWATracker.trackClicks();
  OWATracker.trackDomStream();
} catch(err) {}
//]]>
</script>
```

The `<OWA ...>` bits obviously have to be replaced by the correct values.
