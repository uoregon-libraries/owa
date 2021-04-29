#!/bin/bash
#
# In case files/dirs are mounted in from elsewhere, permissions might not be
# set up properly
chgrp -R www-data /var/www/html
chmod -R g+rx /var/www/html
chown -R www-data /var/www/html/owa-data
chmod -R u+rwx /var/www/html/owa-data
