class addscripts { 
  file { '/etc/example':
    ensure    => directory,
  }

  file  { '/etc/example/checks':
    require   => File['/etc/example'],
    ensure    => directory,
    owner     => root,
  }

  file { '/etc/example/scripts':
    require   => File['/etc/example'],
    ensure    => directory,
    source    => 'puppet:///modules/addscripts',
    recurse   => true,
    mode      => 0755,         
  }

  file {'/bin/decrypt':
    ensure    => link,
    target    => '/etc/example/scripts/decrypt',
  }

  file {'/bin/encrypt':
    ensure    => link,
    target    => '/etc/example/scripts/encrypt',
  }

  file {'/sbin/freemem':
    ensure    => link,
    target    => '/etc/example/scripts/freemem',
  }

  file {'/bin/genpass':
    ensure    => link,
    target    => '/etc/example/scripts/genpass',
  }

  file {'/bin/gram':
    ensure    => link,
    target    => '/etc/example/scripts/gram',
  }
  file {'/bin/space':
    ensure    => link,
    target    => '/etc/example/scripts/space',
  }
 file {'/bin/temp':
   ensure    => link,
   target    => '/etc/example/scripts/temp',
 }

  file {'/sbin/incoming':
    ensure    => link,
    target    => '/etc/example/scripts/incoming',
  }

  file {'/sbin/outgoing':
    ensure    => link,
    target    => '/etc/example/scripts/outgoing',
  }

  file {'/sbin/checks':
    ensure    => link,
    target    => '/etc/example/scripts/checks',
  }
}

