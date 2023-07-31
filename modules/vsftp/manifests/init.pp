class vsftp {
  
  $VSFTPDCONF = template('vsftp/vsftpd.conf.erb')

  package { 'vsftpd':
    ensure  => present,
  }

  file  { '/etc/vsftpd/user_list':
    require => Package['vsftpd'],
    ensure  => present,
    source  => 'puppet:///modules/vsftp/user_list',
    owner   => root,
    group   => root,
    mode    => 0700,
  }

  file { '/etc/vsftpd/vsftpd.conf':
    require => Package['vsftpd'],
    ensure  => present,
    content => $VSFTPDCONF,
    owner   => root,
    group   => root,
    mode    => 0700,
  }

  # user ftpsecure
  user { 'ftpsecure':
    name      => 'ftpsecure',
    shell     => '/sbin/nologin',
    home      => '/home/ftpsecure',
  } 

  file  { '/home/ftpsecure':
    require   => User['ftpsecure'],
    ensure    => directory,
    owner     => root,
    group     => root,
    mode      => 0700,
  }
  
  file  { '/home/ftpsecure/files':
    require   => File['/home/ftpsecure'],
    ensure    => directory,
    owner     => root,
    group     => root,
    mode      => 0700,
  }

  service { 'vsftpd':
    enable  => false,
  } 
}
