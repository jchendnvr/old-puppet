class phpfpm {
  $PHPINI = template('phpfpm/php.ini.erb')

  # packages
  package { 'php-fpm':
    ensure    => present,
  }

  package { 'php-common': 
    ensure    => present,
  }

  package { 'php-mysql': 
    ensure    => present,
  }

  package { 'php-pear': 
    ensure    => present,
  }

  package { 'php-mcrypt': 
    ensure    => present,
  }

  package { 'php-mbstring': 
    ensure    => present,
  }

  package { 'php-intl': 
    ensure    => present,
  }

  package { 'php-gd': 
    ensure    => present,
  }

  package { 'php-devel': 
    ensure    => present,
  }

  package { 'php-xml':
    ensure    => present,
  }

#pecl
  exec  { 'uploadprogress':
    require   => Package['php-pear'],
    command   => '/usr/bin/pecl channel-update pecl.php.net; /usr/bin/pecl install uploadprogress',
    unless    => '/usr/bin/pecl list uploadprogresz | grep not',
  }

# user www-data
  user { 'www-data':
    name      => 'www-data',
    shell     => '/sbin/nologin',
  }

  exec { 'delete-defaults':
    require   => Package['php-fpm'],
    creates   => '/etc/example/checks/php-check',
    command   => '/bin/rm -f /etc/php-fpm.d/www.conf; \
                /bin/rm -f /etc/php.ini; \
                /bin/touch /etc/example/checks/php-check',
  }

# www.conf
  file { '/etc/php-fpm.d/www.conf':
    require   => Package['php-fpm'],
    source    => 'puppet:///modules/phpfpm/www-conf-php',
    owner     => root,
    group     => root,
    mode      => 0644,
    notify    => Service['php-fpm'],
    replace   => no,
  }

# php.ini
  file  { '/etc/php.ini':
    require   => Package['php-fpm'],
    content   => $PHPINI,
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0644,
    notify    => Service['php-fpm'],
    replace   => no,
  }

  file  { '/var/lib/php/sessions':
    require   => File['/etc/php.ini'],
    ensure    => directory,
    owner     => nginx,
    group     => nginx,
  }
  
  service { 'php-fpm':
    require   => File['/var/lib/php/sessions'],
    ensure    => running,
    enable    => true,
  }

}
