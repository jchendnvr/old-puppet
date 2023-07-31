class nginx {

  $SITE1 = template('nginx/example.com.conf.nginx.erb')
  $INDEXHTML = template('nginx/index.html.erb')

# repo
  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-nginx':
    ensure    => present,
    source    => 'puppet:///modules/nginx/RPM-GPG-KEY-nginx',
    owner     => root,
    group     => root,
    mode      => 0644,
  }

  file { '/etc/yum.repos.d/nginx.repo':
    require   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-nginx'],
    ensure    => present,
    source    => 'puppet:///modules/nginx/nginx.repo',
    owner     => root,
    group     => root,
    mode      => 0644,
  }
# package
  package { 'nginx':
    require   => File['/etc/yum.repos.d/nginx.repo'],
    ensure    => present,
  }

# global config
  file  { '/etc/nginx/nginx.conf':
    require   => Package['nginx'],
    ensure    => present,
    source    => 'puppet:///modules/nginx/nginx.conf',
    owner     => root,
    group     => root,
    mode      => 0644,
    notify    => Service['nginx'],
    replace   => yes,
  }
  
# site config
  file  { "/etc/nginx/conf.d/${::fqdn}.conf":
    require   => File['/etc/nginx/nginx.conf'],
    ensure    => present,
    content   => $SITE1,
    owner     => root,
    group     => root,
    mode      => 0644,
    notify    => Service['nginx'],
    replace   => no,
  }

  file  { '/etc/nginx/conf.d/php5-fpm.conf':
    require   => Package['nginx'],
    ensure    => present,
    source    => 'puppet:///modules/nginx/php5-fpm.conf',
    owner     => root,
    group     => root,
    mode      => 0644,
    replace   => no,
  }

  file  { '/usr/share/nginx':
    require   => File["/etc/nginx/conf.d/${::fqdn}.conf"],
    ensure    => directory,
    owner     => nginx,
    group     => nginx,
    mode      => 0700,
  }

  file  { '/usr/share/nginx/html':
    require   => File['/usr/share/nginx'],
    ensure    => directory,
    owner     => nginx,
    group     => nginx,
    mode      => 0700,
  }

  file  { '/usr/share/nginx/site':
    require   => File['/usr/share/nginx'],
    ensure    => directory,
    owner     => nginx,
    group     => nginx,
    mode      => 0700,
  }

  file  { '/usr/share/nginx/site/index.html':
    require   => File['/usr/share/nginx/site'],
    ensure    => present,
    content   => $INDEXHTML,
    owner     => nginx,
    group     => nginx,
    mode      => 0400,
    replace   => no,
  }

  file { '/usr/share/nginx/site/bg.jpg':
    ensure    => present,
    source    => 'puppet:///modules/nginx/pages/bg.jpg',
    owner     => nginx,
    group     => nginx,
    mode      => 0400,
    replace   => no,
  }

  file { '/usr/share/nginx/site/404.html':
    ensure    => present,
    source    => 'puppet:///modules/nginx/pages/404.html',
    owner     => nginx,
    group     => nginx,
    mode      => 0400,
    replace   => no,
  }


  file { '/usr/share/nginx/html/index.html':
    ensure    => present,
    source    => 'puppet:///modules/nginx/pages/index.html',
    owner     => nginx,
    group     => nginx,
    mode      => 0400,
    replace   => yes,
  }

  file { '/usr/share/nginx/html/bg.jpg':
    ensure    => present,
    source    => 'puppet:///modules/nginx/pages/bg.jpg',
    owner     => nginx,
    group     => nginx,
    mode      => 0400,
    replace   => yes, 
  }

  file { '/usr/share/nginx/html/404.html':
    ensure    => present,
    source    => 'puppet:///modules/nginx/pages/404.html',
    owner     => nginx,
    group     => nginx,
    mode      => 0400,
    replace   => yes, 
  }


# service
  service { 'nginx':
    require   => File['/etc/nginx/conf.d/php5-fpm.conf'],
    enable    => true,
    ensure    => running,
  }
}

#nginx.conf  NGINX-GPG-KEY  nginx.repo
