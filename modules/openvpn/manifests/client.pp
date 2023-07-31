# Required Variables
# $VPNServerRealIP
# $VPNClientRealIP
# $VPNServerVPNIP
# $VPNClientVPNIP

class openvpn::client {

$SERVERCONF = "# PUPPET GENERATED CONFIG
remote  ${VPNServerRealIP}
float
port 8000
dev tun
ifconfig ${VPNClientVPNIP} ${VPNServerVPNIP}
persist-tun
persist-local-ip
comp-lzo
ping 15
#keepalive 10 120
secret /etc/openvpn/vpn.key
#route 10.2.2.0 255.255.255.0
#chroot /var/empty
user nobody
group nobody
log /var/log/vpn.log
verb 1
"

  package { 'openvpn':
    ensure    => present,
  }

  file  { '/etc/openvpn':
    require   => Package['openvpn'],
    ensure    => directory,
  }

  file  { '/etc/openvpn/server.conf':
    require   => File['/etc/openvpn'],
    ensure    => present,
    content   => $SERVERCONF,
    notify    => Service['openvpn'],
  }

  # service must be manually started once you copy the vpn key from the server.
  service { 'openvpn':
    require   => File['/etc/openvpn/server.conf'],
    enable    => true,
  }
}
