class base::disableipv6 {
  
  exec { 'disableipv6':
    command   => '/bin/echo "" >> /etc/sysctl.conf; \
      /bin/echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf; \
      /bin/echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf; \
      /bin/echo "1" > /proc/sys/net/ipv6/conf/all/disable_ipv6; \
      /bin/echo "1" > /proc/sys/net/ipv6/conf/default/disable_ipv6;',
    unless    => '/bin/grep "net.ipv6.conf.all.disable_ipv6=1" /etc/sysctl.conf',
  }
}
