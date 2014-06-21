class php {
  package { 'php5-cgi':
    ensure => installed,
    require => Class['httpd']
  }
}
