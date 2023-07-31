class iptables {
  $IPTABLES = template('iptables/iptables.erb')

  exec { 'remove-default-iptables':
    command     => '/bin/rm -f /etc/sysconfig/iptables',
    unless      => '/bin/grep "*filter" /etc/sysconfig/iptables',
  }

  file { '/etc/sysconfig/iptables':
      require   => Class['facts'],
      ensure    => present,
      content   => $IPTABLES,
      replace   => no,
  }

  service { 'iptables':
      require   => File['/etc/sysconfig/iptables'],
      ensure    => running, 
      enable    => true,
      subscribe => File['/etc/sysconfig/iptables'],
  }
}
