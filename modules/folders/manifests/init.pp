class folders {
  file { '/var/www':
    ensure => directory,
    owner => vagrant,
    group => www-data,
    mode => 2755,
    require => Class['httpd'],
  }
}
