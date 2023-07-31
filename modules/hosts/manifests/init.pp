# list of default hosts that should be on every server
class hosts {

  # This block was not needed because puppet had to have the 
  # hosts file at least exist
  # keeping for context
  #
  #host  { 'localhost.localdomain':
  #  ip      => '127.0.0.1',
  #  host_aliases   => 'local',
  #  ensure  => absent,
  #}

  
  host { 'localhost':
    ip            => '127.0.0.1',
    host_aliases  => ['localhost.localdomain','localhost4.localdomain','localhost4.localdomain4'],
  }

  host { "${::fqdn}":
    require       => Host['localhost'],
    ip            => "${::ipaddress}",
    comment       => 'Host managed by puppet',
    host_aliases  => "${::hostname}",
  }

  # puppet masters


  # monitors

  # logs


}

