class php55 {

$PHPINI = template('php55/php.ini.erb')

# Requires remi
  include ::remi

# Packages
  package {'php':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-cli':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-common':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-devel':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-fpm':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-gd':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-imap':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-intl':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-mbstring':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-mcrypt':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-mysqlnd':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-pdo':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-pear':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-pecl-jsonc':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-pecl-jsonc-devel':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-pecl-zip':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
  }

  package {'php-xml':
    ensure  => present,
    require => File['/etc/yum.repos.d/remi.repo'],
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

# delete defaults
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
    source    => 'puppet:///modules/php55/www-conf-php',
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
