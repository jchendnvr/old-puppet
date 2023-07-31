class mariadb {

  $DBHARDEN = template('mariadb/mysql-harden.erb')

# repo
  file  { '/etc/yum.repos.d/maria.repo':
    ensure    => present,
    source    => 'puppet:///modules/mariadb/maria.repo',
    owner     => root,
    group     => root,
    mode      => 0644,
  }

# install packages
  package { 'MariaDB-server':
    require   => File['/etc/yum.repos.d/maria.repo'],
    ensure    => present,
  }

  package { 'MariaDB-client':
    require   => File['/etc/yum.repos.d/maria.repo'],
    ensure    => present,
  }

  exec { 'remove-default-conf':
    require   => Package['MariaDB-server'],
    unless    => '/bin/grep "In Prod" /etc/my.cnf',
    command   => '/bin/rm -f /etc/my.cnf',
  }

# configuration
  file  { '/etc/my.cnf':
    require   => Package['MariaDB-server'],
    ensure    => present,
    source    => 'puppet:///modules/mariadb/maria-cnf',
    owner     => root,
    group     => root,
    mode      => 0644,
    replace   => no,
    notify    => Service['mysql'],
  }

# service
  service { 'mysql':
    require   => File['/etc/my.cnf'],
    ensure    => running,
    enable    => true,
  }


# harden script
#  file  { '/etc/example/checks':
#    require   => '/etc/example',
#    ensure    => directory,
#    owner     => root,
#    group     => root,
#    mode      => 0700,
#  }

  file  { '/etc/example/checks/mysql-harden':
    require   => Service['mysql'],
    ensure    => present,
    content   => $DBHARDEN,
    owner     => root,
    group     => root,
    mode      => 0400,
    replace   => yes,
  }

# harden
  exec  { 'harden':
    require   => File['/etc/example/checks/mysql-harden'],
    cwd       => '/etc/example/checks',
    creates   => '/etc/example/checks/mysql-hardened',
    command   => '/usr/bin/mysql < /etc/example/checks/mysql-harden; \
                  /bin/touch /etc/example/checks/mysql-hardened; \
                  /bin/echo "Operation Performed" > /etc/example/checks/mysql-harden',
  }

# backupuser
  exec { 'backupuser':
    require   => Exec['harden'],
    #require   => '/etc/example/checks/mysql-hardened',
    creates   => '/etc/example/checks/mysql-backupuser',
    command   => "/usr/bin/mysql -uroot -p${ROOTDBPASS} -e \"GRANT LOCK TABLES, SELECT on *.* to 'backupuser'@'%' IDENTIFIED BY '${BACKUPUSERPASS}';\"; \
    /bin/touch /etc/example/checks/mysql-backupuser",
  }

  file { '/root/db':
    require   => Exec['backupuser'],
#    require   => '/etc/example/checks/mysql-backupuser',
    ensure    => directory,
    owner     => root,
    group     => root,
    mode      => 0700,
  }

#daily db-dump
  cron  { 'mysqldump':
    require   => File['/root/db'],
    command   => "/usr/bin/mysqldump -ubackupuser -p${BACKUPUSERPASS} --all-databases | gzip > /root/db/`date '+\%Y\%m\%d-\%H-\%M'`-backup.sql.gz",
    user      => root,
    hour      => 1,
    minute    => 0,
  }
#clean old db-dumps
  cron  { 'dumpclean':
    require   => Cron['mysqldump'],
    command   => '/bin/find /root/db/*-backup.sql.gz -mtime +10 -exec rm {} \;',
    user      => root,
    hour      => 0,
    minute    => 45,
  }
}
