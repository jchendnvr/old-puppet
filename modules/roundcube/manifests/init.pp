class roundcube {
  include email::full

  package { 'php-domxml-php4-php5':
    ensure    => present,
  }

  file { '/usr/share/nginx/roundcube':
    require   => Package['php-domxml-php4-php5'],
    ensure    => directory,
    source    => 'puppet:///modules/roundcube/roundcubemail-1.0.6',
    recurse   => true,
    mode      => 0755,    
    owner     => nginx,
    group     => nginx,
  }

  # requires $ROUNDCUBEDBPASS
  include roundcube::db

}
