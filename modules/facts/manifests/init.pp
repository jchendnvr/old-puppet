# loads facts to the ${rubysitedir}/facter dir of each server. 
# this allows them to be used natively from the command line

class facts {

    file { "${::rubysitedir}/facter/nameservers.rb":
      ensure  => present,
      source  => 'puppet:///modules/facts/nameservers.rb',
      before  => File['/etc/sysconfig/iptables'],
    }
}
#    require   => File['/etc/example'],
#    ensure    => directory,
#    source    => 'puppet:///modules/addscripts',

