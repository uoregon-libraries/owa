#!/bin/bash
#
# If the server is totally new, we have to copy in the install file, but if it
# isn't, we absolutely do *not* want to do this.
setup_installer() {
  cp /var/www/owa-install.php /var/www/html/install.php
}

php /var/www/html/is-installed.php || setup_installer
