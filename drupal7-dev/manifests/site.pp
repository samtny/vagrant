# utils

package { ["vim", "git", "drush"]:
  ensure => latest,
}

# shared

file { ["/vagrant/data", "/vagrant/data/drupal7-core", "/vagrant/data/drupal7-common"]:
  ensure => directory,
  owner => "vagrant",
  group => "www-data",
  mode => 2774,
}

# www

file { "/var/www":
  ensure => directory,
  owner => "vagrant",
  group => "www-data",
  mode => 2774,
}
file { ["/var/www/drupal7-core"]:
  ensure => symlink,
  target => "/vagrant/data/drupal7-core",
  require => File["/vagrant/data/drupal7-core"],
}
file { ["/var/www/drupal7-core/docroot", "/var/www/drupal7-core/docroot/sites"]:
  ensure => directory,
  owner => "vagrant",
  require => File["/var/www"],
}
file { ["/var/www/drupal7-core/docroot/sites/all"]:
  ensure => symlink,
  owner => "vagrant",
  target => "/vagrant/data/drupal7-common",
}

# site

define drupal7::drupal7site($shortname) {
  file { "local.${name}.conf":
    path => "/etc/nginx/sites-available/local.${name}.conf",
    owner => "root",
    group => "root",
    mode => "0644",
    content => template("drupal7site.erb"),
    require => Package["nginx"],  
  }

  file { "/etc/nginx/sites-enabled/local.${name}.conf":
    ensure => symlink,
    target => "/etc/nginx/sites-available/local.${name}.conf",
    require => File["/etc/nginx/sites-available/local.${name}.conf"],
    notify => Service["nginx"],
  }

  file { ["/vagrant/data/${name}"]:
    ensure => directory,
    owner => "vagrant",
  }

  file { ["/var/www/drupal7-core/docroot/sites/${name}"]:
    ensure => symlink,
    target => "/vagrant/data/${name}",
  }

  file { ["/var/www/drupal7-core/docroot/sites/${name}/settings.php"]:
    ensure => present,
    content => template("settings.php.erb"),
    owner => "vagrant",
    require => File["/var/www/drupal7-core/docroot/sites/${name}"];
  }

  file { ["/var/www/drupal7-core/docroot/sites/${name}/files"]:
    ensure => directory,
    owner => "vagrant",
    require => File["/var/www/drupal7-core/docroot/sites"],
  }

  mysql_database { "my_ami_${shortname}":
    ensure => present,
    charset => "utf8",
    collate => "utf8_general_ci",
    require => Service["mysql"],
  }

  mysql_user { "ami_${shortname}@%":
    ensure => present,
    password_hash => "*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19",
    require => Service["mysql"],
  }

  mysql_grant { "ami_${shortname}@%/my_ami_${shortname}.*":
    ensure => present,
    options => ["GRANT"],
    privileges => ["ALL"],
    table => "*.*",
    user => "ami_${shortname}@%",
    require => Service["mysql"],
  }
}

drupal7::drupal7site { "flexonline.com":
  shortname => "flex",
}

drupal7::drupal7site { "naturalhealthmag.com":
  shortname => "nh",
}

# nginx

user { "nginx":
  ensure => present,
  groups => "www-data",
}
package { "nginx":
  ensure => latest,
}
service { "nginx":
  ensure => running,
  require => Package["nginx"],
}
file { "/etc/nginx/nginx.conf":
  content => template("nginx.conf"),
  require => Package["nginx"],
  notify => Service["nginx"],
}

# mysql

package { "mysql-server":
  ensure => latest,
}
service { "mysql":
  ensure => running,
  require => Package["mysql-server"],
}
file { "/etc/mysql/my.cnf":
  ensure => present,
  content => template("my.cnf"),
  require => Package["mysql-server"],
  notify => Service["mysql"],
}
file { "/etc/security/limits.d/mysql.limits.conf":
  ensure => present,
  content => template("mysql.limits.conf"),
  notify => Service["mysql"],
}

# php

package { "php-apc":
  ensure => latest,
}

# php5-fpm

package { "php5-fpm":
  ensure => latest,
}
service { "php5-fpm":
  ensure => running,
  require => Package["php5-fpm"],
}
file { "/etc/php5/fpm/pool.d/www.conf":
  ensure => present,
  content => template("www.conf"),
  notify => Service["php5-fpm"],
}
file { "/etc/php5/fpm/php.ini":
  ensure => present,
  content => template("php.ini"),
  require => Package["php5-fpm"],
  notify => Service["php5-fpm"],
}

# php modules

file { "/etc/php5/conf.d/apc.ini":
  ensure => present,
  content => template("apc.ini"),
  require => Package["php5-fpm"],
  notify => Service["php5-fpm"],
}

package { "php5-mysql":
  ensure => latest,
  require => Package["php5-fpm", "mysql-server"],
  notify => Service["php5-fpm"],
}

package { "php5-memcached":
  ensure => latest,
  require => Package["php5-fpm", "memcached"],
  notify => Service["php5-fpm"],
}
file { "/etc/php5/conf.d/memcached.ini":
  ensure => present,
  content => template("memcached.ini"),
  require => Package["php5-fpm", "php5-memcached"],
  notify => Service["php5-fpm"],
}

# memcache

package { "memcached":
  ensure => latest,
}
service { "memcached":
  ensure => running,
}
file { "/etc/memcached.conf":
  ensure => present,
  content => template("memcached.conf"),
  require => Package["memcached"],
  notify => Service["memcached"],
}

