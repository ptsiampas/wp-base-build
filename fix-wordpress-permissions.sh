#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# Author: Michael Conigliaro <mike [at] conigliaro [dot] org>
#
WP_OWNER=33 # <-- wordpress owner
WP_GROUP=33 # <-- wordpress group
WP_ROOT=$(pwd)/data/wp # <-- wordpress root directory
WS_GROUP=33 # <-- webserver group

# reset to safe defaults
find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
find ${WP_ROOT} -type d -exec sudo chmod 755 {} \;
find ${WP_ROOT} -type f -exec sudo chmod 644 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
sudo chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
sudo chmod 660 ${WP_ROOT}/wp-config.php

# allow wordpress to manage wp-content
find ${WP_ROOT}/wp-content -exec sudo chgrp ${WS_GROUP} {} \;
find ${WP_ROOT}/wp-content -type d -exec sudo chmod 775 {} \;
find ${WP_ROOT}/wp-content -type f -exec sudo chmod 664 {} \;
