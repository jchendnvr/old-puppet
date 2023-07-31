# Required Variables
# $TIMEZONE based on values in /usr/share/zoneinfo/
# Dont use US dir ones because of PHP

class ntpd::timezone {
  file { '/etc/localtime':
    ensure  => link,
    target  => "/usr/share/zoneinfo/${TIMEZONE}",
  }
}



