class base::vnstat {
  package { 'vnstat': 
    require   => File['/etc/yum.repos.d/epel.repo'],   
    ensure    => present,
  }

  service { 'vnstat':
    require   => Package['vnstat'],
    ensure    => running,
    enable    => true,
  }

  cron { 'vnstat':
    require   => Service['vnstat'],
    command   => "/usr/bin/vnstat -m --style 3 | /bin/mail -s \'Monthly Bandwidth for ${::fqdn}\' root",
    user      => root,
    hour      => 0,
    minute    => 15,
    
  }

}
