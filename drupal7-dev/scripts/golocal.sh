#!/bin/bash

set -x

drush cc drush

drush vset -exact file_temporary_path '/tmp'

drush updb -y
drush fra -y

drush dis acquia_agent -y
drush dis acquia_purge -y

drush dl devel -y
drush en devel -y

drush vset -exact error_level 1
drush vset -exact preprocess_css 0
drush vset -exact preprocess_js 0
drush vset -exact devel_xhprof_directory '/usr/share/php'
drush vset -exact devel_xhprof_url 'http://192.168.33.11/xhprof_html'
drush vset -exact views_skip_cache 1

