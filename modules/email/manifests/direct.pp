# Required variables
# ROOTEMAIL - called EMAILADDRMAIN previously

# postfix-direct.main.cf
class email::direct {

  $POSTFIX = template('email/postfix-direct.main.cf.erb')

  exec  { 'setroot':
    creates   => '/etc/example/checks/set-root',
    command   => "/bin/echo ' ' >> /etc/aliases; \
        /bin/echo 'root:    $ROOTEMAIL' >> /etc/aliases; \
        /usr/bin/newaliases; \
        /bin/touch /etc/example/checks/set-root"
  }

  package { 'mailx':
    ensure    => present,
  }

  file  { '/etc/postfix/main.cf':
    ensure    => present,
    content   => $POSTFIX,
    owner     => root,
    group     => root,
  }

  service { 'postfix':
    require   => File['/etc/postfix/main.cf'],
    ensure    => running,
    enable    => true,
  }
}
