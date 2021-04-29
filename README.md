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
3. If desired, copy `docker/owa.sql` into `docker/mysql-init` to skip some of
   the web-wizard setup.  This will create the database structure as well as
   install an administrative user.  You will be able to log in as "adm" with
   the password "adm".  You **must** change this for production.

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

An easy way to generate random text for passwords/keys/salts:

```bash
cat /dev/urandom | tr -dc 'a-zA-Z0-9_-' | fold -w 30 | head -n 1
```

Change the allowed `tr` list as needed, change the fold width as needed, change
the `head` number to generate more passwords at once, etc.
