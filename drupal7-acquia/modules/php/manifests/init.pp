class php {
  package { [ 'php5-cli', 'php5-common', 'php5-mysql', 'php5-gd', 'php5-fpm', 'php5-cgi', 'php-pear', 'php5-memcache', 'php-apc' ]:
    ensure => installed,
    require => Class['httpd'],
  }
}
