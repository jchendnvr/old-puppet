# Required Variables
# ROOTEMAIL previously called EMAILADDRMAIN
# RELAYSERVER
# RELAYEMAILUSER
# RELAYEMAILPASS
#


class email::relay {
  $POSTFIX = template('email/postfix-relay.main.cf.erb')

  package { 'mailx':
    ensure    => present,
  }

  package { 'cyrus-sasl-plain':
    ensure    => present,  
  }

  exec  { 'setroot':
    creates   => '/etc/example/checks/set-root',
    command   => "/bin/echo ' ' >> /etc/aliases; \
        /bin/echo 'root:    $ROOTEMAIL' >> /etc/aliases; \
        /usr/bin/newaliases; \
        /bin/touch /etc/example/checks/set-root"
  }

  exec  { 'setsasl':
    require   => Package['cyrus-sasl-plain'],
    creates   => '/etc/example/checks/set-sasl',
    command   => "/bin/echo '${::fqdn}    $RELAYEMAILUSER:$RLAYEMAILPASS' > /etc/postfix/sasl_passwd; \
      /usr/sbin/postmap hash:/etc/postfix/sasl_passwd; \
      /bin/touch /etc/example/checks/set-sasl",
  }

  file { '/etc/postfix/sasl_passwd':
    require   => Exec['setsasl'],
    owner     => root,
    group     => root,
    mode      => 0600,
  }

  file  { '/etc/postfix/sasl_passwd.db':
    require   => Exec['setsasl'],
    owner     => root,
    group     => root,
    mode      => 0600,
  }

  file  { '/etc/postfix/main.cf':
    require   => File['/etc/postfix/sasl_passwd.db'],
    content   => $POSTFIX,
  }

  service { 'postfix':
    require   => File['/etc/postfix/main.cf'],
    enable    => true,
    ensure    => running,
  }

  service { 'saslauthd': 
    require   => Service['postfix'],
    enable    => true,
    ensure    => running,
  }
}
