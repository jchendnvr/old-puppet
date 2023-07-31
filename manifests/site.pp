#################################################
# Required Variables 
# These variables must be declared per node or 
# they will get the default value provided. 
################################################

# INTERNAL or CLIENT
$SSH = 'CLIENT'

# Timezones located at /usr/share/zoneinfo
# Do not use ones in US dir. 
$TIMEZONE = 'America/Denver'
$PHPTIMEZONE = $TIMEZONE

# SSL
$DORG= "${::fqdn}"                   # O   Common Organization Name
$DN = "${::fqdn}"                   # CN
$DOU ='IT'                        # OU, can be left at IT
$DCOUNTRY ='US'                   # C 
$DSTATE ='COLORADO'               # ST
$DCITY ='DENVER'                  # L 
$DEMAIL = 'admin@example.com'

$ALLOWPORTS = [80,443]

$ROOTDBPASS = 'YOUR_ROOT_DB_PASS'

################################################
# End of Required Variables list
################################################


# testing nodes with manually created manifests in site.pp
node 'test2.example.com' {
  # H
  $ALLOWPORTS = [80,443,5123]
  $IPPORTS = ['192.168.222.222|15555']
  $SSH = 'INTERNAL'
  $TIMEZONE = 'America/Denver'
	notify {"Hello this is ${::hostname} with the fqdn ${::fqdn}.":}
	include base
  include hosts
  include iptables
  include nginx
  include phpfpm
  include mariadb
}

node 'test3.example.com' {
  $ALLOWPORTS = [20,21,80,443]
  $SSH = 'INTERNAL'
  include base
  include hosts
  include iptables
  include nginx
  include phpfpm
  include mariadb
  include vsftp
  #include dkim
}

# import client and internal machine manifests
import 'biz/*.pp' 
import 'int/*.pp'

# Default node to prevent no node configured error. 
node default {
  notify {'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
NO NODE CONFIGURED - > CONFIGURE NODE NOW!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!':
  }
}
