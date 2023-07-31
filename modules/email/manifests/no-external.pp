class email::no-external {
  
  package { 'mailx':
    ensure    => present,
  }
  
  file  { '/etc/postfix/main.cf':
    ensure    => present,
    source    => 'puppet:///modules/email/postfix-no-external.main.cf',
    notify    => Service['postfix'],
  }

  service { 'postfix':
    require   => File['/etc/postfix/main.cf'],
    enable    => true,
    ensure    => running,
  }
  
}
