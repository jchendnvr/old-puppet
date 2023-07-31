# packages that should be added to every server
# if package includes a service group it near

class base::add_packages {
  package { 'tree':
    ensure  => present, 
  }

  package {'git':
    ensure  => present,
  }

  package {'tcpdump':
    ensure  => present,
  }
  
  package {'nmap':
    ensure  => present,
  }
 
  package {'sysstat':
    ensure  => present,
  }

  package { 'powertop':
    ensure  => present,
  }

  package { 'nload':
    require => Class['base::epel_repo'],
    ensure  => present,
  } 
  
  file { '/etc/nload.conf':
    require => Package['nload'],
    ensure  => present,
    source  => 'puppet:///modules/base/nload',
    owner   => root,
    group   => root,
    mode    => 0644,
  }
  
  package { 'glances':
    require => Class['base::epel_repo'],
    ensure  => present,
  }
}
