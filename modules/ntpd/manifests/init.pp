class ntpd {

  package { 'ntp':
    ensure    => present, 
  }

  package { 'ntpdate':
    ensure    => present,
  }

  file { 'ntp.conf':
    require   => Package['ntp'],
    path      => '/etc/ntp.conf',
    source    => 'puppet:///modules/ntpd/ntp.conf',
    owner     => 'root',
    group     => 'root',
    mode      => 0644,
    notify    => Service['ntpd'],
  }

  service { 'ntpd':
    subscribe => File['ntp.conf'],
    ensure    => running,
    enable    => true,
  }

  #include ntpd::timezone
}
