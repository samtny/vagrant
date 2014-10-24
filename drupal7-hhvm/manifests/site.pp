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
file { "/etc/nginx/sites-available/default":
  content => template("default"),
  require => Package["nginx"],
  notify => Service["nginx"],
}
file { "/etc/nginx/sites-enabled/default":
  ensure => symlink,
  target => "/etc/nginx/sites-available/default",
  require => File["/etc/nginx/sites-available/default"],
}

# mysql

service { "mysql":
  ensure => running,
}
file { "/etc/mysql/my.cnf":
  ensure => present,
  content => template("my.cnf"),
  notify => Service["mysql"],
}
file { "/etc/my.cnf":
  ensure => symlink,
  target => "/etc/mysql/my.cnf",
}
file { "/etc/security/limits.d/mysql.limits.conf":
  ensure => present,
  content => template("mysql.limits.conf"),
  notify => Service["mysql"],
}

# hhvm

package { "hhvm":
  ensure => latest,
}
service { "hhvm":
  ensure => running,
  require => Package["hhvm"],
}
file { "/etc/hhvm/server.ini":
  ensure => present,
  content => template("server.ini"),
  notify => Service["hhvm"],
}
file { "/etc/hhvm/php.ini":
  ensure => present,
  content => template("php.ini"),
  require => Package["hhvm"],
  notify => Service["hhvm"],
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

# util

package { ["vim", "git", "curl"]:
  ensure => latest,
}

file { "/home/vagrant/bin":
  ensure => directory,
}
file { "/home/vagrant/bin/golocal":
  content => template("golocal.erb"),
  owner => "vagrant",
  group => "vagrant",
  mode => 755,
}
file { "/home/vagrant/bin/dbload":
  content => template("dbload"),
  owner => "vagrant",
  group => "vagrant",
  mode => 755,
}

# www

file { ["/var/www", "/var/www/drupal7-core", "/var/www/drupal7-core/docroot", "/var/www/drupal7-core/docroot/sites", "/var/www/drupal7-core/docroot/sites/all"]:
  ensure => directory,
  owner => "vagrant",
  group => "www-data",
  mode => 2775,
}

file { ["/var/www/drupal7-core/docroot/install.php"]:
  content => template("install.php"),
  owner => "vagrant",
  group => "www-data",
  require => File["/var/www/drupal7-core/docroot"],
}

# nfs

package { ["nfs-kernel-server"]:
  ensure => latest,
}
service { ["nfs-kernel-server"]:
  ensure => running,
  require => Package["nfs-kernel-server"],
}
file { "/etc/exports":
  ensure => present,
  content => template("exports"),
  require => [ File["/var/www"], Package["nfs-kernel-server"] ],
  notify => [ Service["nfs-kernel-server"], Exec["exportfs"] ],
}
exec { exportfs:
  path => ["/usr/bin", "/usr/sbin"],
  command => "exportfs -a",
  refreshonly => true,
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
    notify => Service["nginx"],
  }

  file { "/etc/nginx/sites-enabled/local.${name}.conf":
    ensure => symlink,
    target => "/etc/nginx/sites-available/local.${name}.conf",
    require => File["/etc/nginx/sites-available/local.${name}.conf"],
  }

  file { ["/var/www/drupal7-core/docroot/sites/${name}"]:
    ensure => directory,
    owner => "vagrant",
    group => "www-data",
    mode => "2755",
  }

  file { ["/var/www/drupal7-core/docroot/sites/${name}/files"]:
    ensure => directory,
    owner => "vagrant",
    group => "www-data",
    mode => "2775",
    require => File["/var/www/drupal7-core/docroot/sites/${name}"],
  }

  file { ["/var/www/drupal7-core/docroot/sites/${name}/settings.php"]:
    ensure => present,
    content => template("settings.php.erb"),
    owner => "vagrant",
    group => "www-data",
    mode => 755,
    require => File["/var/www/drupal7-core/docroot/sites/${name}"],
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
    table => "my_ami_${shortname}.*",
    user => "ami_${shortname}@%",
    require => Service["mysql"],
  }

  file_line { "hosts_${shortname}":
    path => "/etc/hosts",
    line => "127.0.0.1  local.${name}",
  }

  file_line { "cd${shortname}":
    path => "/home/vagrant/.profile",
    line => "alias cd${shortname}=\"cd /var/www/drupal7-core/docroot/sites/${name}\"",
  }
}

drupal7::drupal7site { "flexonline.com":
  shortname => "flex",
}

drupal7::drupal7site { "naturalhealthmag.com":
  shortname => "nh",
}

drupal7::drupal7site { "fitpregnancy.com":
  shortname => "fp",
}

drupal7::drupal7site { "muscleandfitness.com":
  shortname => "maf",
}

drupal7::drupal7site { "shape.com":
  shortname => "shape",
}

drupal7::drupal7site { "mensfitness.com":
  shortname => "mf",
}

# diagnostics 

file { "/var/www/phpinfo.php":
  content => template("phpinfo.php"),
  owner => "vagrant",
  group => "www-data",
  require => File["/var/www"],
}

file { "/var/www/apc.php":
  content => template("apc.php"),
  owner => "vagrant",
  group => "www-data",
  require => File["/var/www"],
}

file { "/var/www/realpath.php":
  content => template("realpath.php"),
  owner => "vagrant",
  group => "www-data",
  require => File["/var/www"],
}

file { "/var/www/xhprof_html":
  ensure => symlink,
  target => "/usr/share/php/xhprof_html",
}

