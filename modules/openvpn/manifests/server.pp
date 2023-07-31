# Required Variables
# $VPNServerRealIP
# $VPNClientRealIP
# $VPNServerVPNIP
# $VPNClientVPNIP

class openvpn::server {

$SERVERCONF = "# PUPPET GENERATED CONFIG
remote  ${VPNClientRealIP}
float
port 8000
dev tun
ifconfig ${VPNServerVPNIP} ${VPNClientVPNIP}
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

  exec  { 'genkey':
    require   => File['/etc/openvpn'],
    creates   => '/etc/openvpn/vpn.key',
    command   => '/usr/sbin/openvpn --genkey --secret /etc/openvpn/vpn.key',
  }

  file  { '/etc/openvpn/server.conf':
    require   => File['/etc/openvpn'],
    ensure    => present,
    content   => $SERVERCONF,
    notify    => Service['openvpn'],
  }

  service { 'openvpn':
    require   => File['/etc/openvpn/server.conf'],
    enable    => true,
    ensure    => running,
  }
}
