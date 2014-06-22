class httpd {
  class { 'apache':
    default_vhost => true,
    mpm_module => 'worker',
    serveradmin => 'vagrant@localhost',
  }
  
  apache::mod { 'fastcgi': }

  #package { 'libapache2-mod-fastcgi':
  #  ensure => installed,
  #  notify => Service['apache2'],
  #}
}
