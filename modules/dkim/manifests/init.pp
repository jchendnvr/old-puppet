class dkim {

  $KEYTABLE = template('dkim/KeyTable.erb')
  $SIGNINGTABLE = template('dkim/SigningTable.erb')
  $TRUSTEDHOSTS = template('dkim/TrustHosts.erb')

  package { 'opendkim':
    require   => File['/etc/yum.repos.d/epel.repo'],
    ensure    => present,
  }

  file  { '/etc/opendkim.conf':
    require   => Package['opendkim'],
    ensure    => present,
    source    => 'puppet:///modules/dkim/opendkim.conf',
  }

  file  { "/etc/opendkim/keys/${::fqdn}":
    require   => File['/etc/opendkim.conf'],
    ensure    => directory,
    owner     => root,
    group     => opendkim,
    mode      => 0740,
  }

  exec  { 'createkeys':
    require   => File["/etc/opendkim/keys/${::fqdn}"],
    command   => "/usr/sbin/opendkim-genkey -D /etc/opendkim/keys/${::fqdn}/ -d ${::fqdn} -s default",
    creates   => "/etc/opendkim/keys/${::fqdn}/default.txt", 
  }

  file  { "/etc/opendkim/keys/${::fqdn}/default.txt":
    require   => Exec['createkeys'],
    owner     => root,
    group     => opendkim,
    mode      => 0644,
    replace   => no,
    notify    => Service['opendkim'],
  }

  file  { "/etc/opendkim/keys/${::fqdn}/default.private":
    require   => Exec['createkeys'],
    owner     => root,
    group     => opendkim,
    mode      => 0640,
    replace   => no,
    notify    => Service['opendkim'],
  } 

  exec  { 'remove-default-files':
    require   => Package['opendkim'],
    creates   => '/etc/example/checks/dkim-check',
    command   => '/bin/rm -f /etc/opendkim/KeyTable; \
      /bin/rm -f /etc/opendkim/SigningTable;\
      /bin/rm -f /etc/opendkim/TrustedHosts;\
      /bin/touch /etc/example/checks/dkim-check',
  }

  file  { '/etc/opendkim/KeyTable':
    require   => Package['opendkim'],
    ensure    => present,
    content   => $KEYTABLE,
    replace   => no,
    notify    => Service['opendkim'],
  }

  file  { '/etc/opendkim/SigningTable':
    require   => File['/etc/opendkim/KeyTable'],
    ensure    => present,
    content   => $SIGNINGTABLE,
    replace   => no,
    notify    => Service['opendkim'],
  }

  file  { '/etc/opendkim/TrustedHosts':
    require   => File['/etc/opendkim/SigningTable'],
    ensure    => present,
    content   => $TRUSTEDHOSTS,
    replace   => no,
    notify    => Service['opendkim'],
  }

  service { 'opendkim':
    require   => File['/etc/opendkim/TrustedHosts'],
    enable    => true,
    ensure    => running,
  }

  exec  { 'copy-keys':
    require   => Exec['createkeys'],
    command   => "/bin/cat /etc/opendkim/keys/${::fqdn}/default.txt > /root/dkim-pub.txt",
    creates   => '/root/dkim-pub.txt',
  }
}
