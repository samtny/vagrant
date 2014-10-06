class mysql {
  package { 'percona-server-server-5.5':
    ensure => installed,
  }

  package { 'percona-server-client-5.5':
    ensure => installed,
  }
}
