# Required Variables
# ROOTEMAIL previously called EMAILADDRMAIN
#

class email::full {
  
  # Required Class
  include dkim 

  $POSTFIX = template('email/postfix-full.main.cf.erb')
  $DOVECOT = template('email/dovecot-full.dovecot.conf.erb')

  exec  { 'setroot':
    creates   => '/etc/example/checks/set-root',
    command   => "/bin/echo ' ' >> /etc/aliases; \
        /bin/echo 'root:    $ROOTEMAIL' >> /etc/aliases; \
        /usr/bin/newaliases; \
        /bin/touch /etc/example/checks/set-root",
  }

  package { 'dovecot':
    ensure    => present,
  }

  package { 'dovecot-pigeonhole':
      ensure    => present,
  }

  package { 'mailx':
    ensure    => present,
  }

  file { '/etc/postfix/main.cf':
    ensure    => present,
    content   => $POSTFIX,
    mode      => 0644,
  }
  
  file { '/etc/postfix/master.cf':
    require   => File['/etc/postfix/main.cf'],
    ensure    => present,
    source    => 'puppet:///modules/email/postfix-full.master.cf',
    mode      => 0644,
  }

  file  { '/etc/dovecot/dovecot.conf':
    require   => Package['dovecot'],
    ensure    => present,
    content    => $DOVECOT,
    mode      => 0644,
  }

  file { '/etc/dovecot/expunge.sh':
    require   => Package['dovecot'],
    ensure    => present,
    source    => 'puppet:///modules/email/dovecot.expunge.sh',
    mode      => 0600,
  }

  service { 'postfix':
    require   => File['/etc/postfix/master.cf'],
    ensure    => running,
    enable    => true,
  }

  service { 'dovecot':
    require   => File['/etc/dovecot/dovecot.conf'],
    ensure    => running,
    enable    => true,
  }

  cron { 'dovecotsearch':
    require   => Service['dovecot'],
    command   => '/usr/bin/doveadm -v search -A text xXyYzZ',
    user      => root,
    hour      => 1,
    minute    => 30,
  }

  cron  { 'expunge':
    require   => File['/etc/dovecot/expunge.sh'],
    command   => 'etc/dovecot/expunge.sh',
    user      => root,
    hour      => 1,
    minute    => 45,
  }
# dovecot.expunge.sh
# dovecot-full.dovecot.conf
# postfix-full.main.cf
# postfix-full.master.cf

}
