# Required Variables
# $secondnic
# $secondip
# $secondnm


class secondnic {
  $nicfile = "# Set by puppet module second nic
#ifcfg ${secondnic}
DEVICE='${secondnic}'
BOOTPROTO='static'
IPV6INIT='no'
IPV6_AUTOCONF='no'
ONBOOT='yes'
TYPE='Ethernet'
IPADDR='${secondip}'
NETMASK='${secondnm}'
"
  file  { "/etc/sysconfig/network-scripts/ifcfg-${secondnic}":
    ensure    => present,
    content   => $nicfile,
    notify    => Service['network'],
  }

  service { 'network':
    ensure    => running,  
  }
}
