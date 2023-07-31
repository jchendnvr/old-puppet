# Required Variables
# adminpass

class backuppc {

  $SSLCONF  = template('backuppc/sslconf.erb')
  $CONFIGPL = template('backuppc/configpl.erb')

# create backuppc user
  user  { 'backuppc':
    name      => 'backuppc',
    shell     => '/sbin/nologin',
    ensure    => present,
  }

  group { 'backuppc':
    require   => User['backuppc'],
    name      => 'backuppc',
    ensure    => present,
    members   => 'backuppc',
  }

  file { '/home/backuppc':
    require   => User['backuppc'],
    ensure    => directory,
    owner     => 'backuppc',
    group     => 'backuppc',
    mode      => 0700,
  }

  exec  { 'backuppcsudoers':
    require   => User['backuppc'],
    creates   => '/etc/example/checks/backuppc-sudoers',
    command   => '/bin/echo "
Defaults !lecture
backuppc ALL=(ALL) NOPASSWD:/bin/gtar,/bin/tar
" >> /etc/sudoers; \
    /bin/touch /etc/example/checks/backuppc-sudoers',
  }

# bash_profile to include path
  file  { '/home/backuppc/.bash_profile':
    require   => File['/home/backuppc'],
    ensure    => present,
    source    => 'puppet:///modules/backuppc/bashprofile',
    owner     => backuppc,
    group     => backuppc,
    mode      => 0400,
  }


# install packages
  package { 'rsync':
    require   => Exec['backuppcsudoers'],
    ensure    => present,
  }
  
  package { 'perl-Compress-Zlib':
    require   => Package['rsync'],
    ensure    => present,
  }

  package { 'perl-Archive-Zip':
    require   => Package['perl-Compress-Zlib'],
    ensure    => present,
  }
 
  package { 'perl-File-RsyncP':
    require   => Package['perl-Archive-Zip'],
    ensure    => present,
  }
 
  package { 'perl-XML-RSS':
    require   => Package['perl-File-RsyncP'],
    ensure    => present,
  }
 
  package { 'mod_perl':
    require   => Package['perl-XML-RSS'],
    ensure    => present,
  }
 
  package { 'perl-suidperl':
    require   => Package['mod_perl'],
    ensure    => present,
  }
 
  package { 'mod_ssl':
    require   => Package['perl-suidperl'],
    ensure    => present,
  }

  package { 'backuppc':
    require   => Package['mod_ssl'],
    ensure    => present,
  }

# create backuppc user ssh keys
  file  { '/var/lib/BackupPC/.ssh':
    require   => Package['backuppc'],
    ensure    => directory,
    owner     => backuppc,
    group     => backuppc,
    mode      => 0700,
  }

  exec  { 'sshkeys':
    require   => File['/var/lib/BackupPC/.ssh'],
    creates   => '/var/lib/BackupPC/.ssh/id_rsa.pub',
    command   => "/usr/bin/ssh-keygen -t rsa -N '' -b 4096 -f /var/lib/BackupPC/.ssh/id_rsa -C \"${::hostname}\"", 
  }

  file  { '/var/lib/BackupPC/.ssh/id_rsa':
    require   => Exec['sshkeys'],
    owner     => backuppc,
    group     => backuppc,
    mode      => 0400,
  }

  file  { '/var/lib/BackupPC/.ssh/id_rsa.pub':
    require   => Exec['sshkeys'],
    owner     => backuppc,
    group     => backuppc,
    mode      => 0400,
  }
  
  exec  { 'copysshkey':
    require   => File['/var/lib/BackupPC/.ssh/id_rsa.pub'],
    creates   => '/home/backuppc/.ssh/id_rsa.pub',
    command   => '/bin/cp -R /var/lib/BackupPC/.ssh /home/backuppc/',
  }

  file  { '/home/backuppc/.ssh':
    require   => Exec['copysshkey'],
    owner     => 'backuppc',
    group     => 'backuppc',
    mode      => 0700,
  }
  
  file  { '/home/backuppc/.ssh/id_rsa':
    require   => File['/home/backuppc/.ssh'],
    owner     => 'backuppc',
    group     => 'backuppc',
    mode      => 0400,
  }

  file  { '/home/backuppc/.ssh/id_rsa.pub':
    require   => File['/home/backuppc/.ssh'],
    owner     => 'backuppc',
    group     => 'backuppc',
    mode      => 0400,
  }

  exec  { 'copysshpub':
    require   => File['/var/lib/BackupPC/.ssh/id_rsa.pub'],
    creates   => '/root/id_rsa.pub',
    command   => '/bin/cp /var/lib/BackupPC/.ssh/id_rsa.pub /root/id_rsa.pub',
  }

# create web user 
  exec  { 'webuser':
    require   => Package['backuppc'],
    creates   => '/etc/BackupPC/apache.users',
    command   => "/usr/bin/htpasswd -b -c /etc/BackupPC/apache.users admin ${adminpass}",
  }

# httpd.conf
  file  { '/etc/httpd/conf/httpd.conf':
    require   => Package['backuppc'],
    ensure    => present,
    source    => 'puppet:///modules/backuppc/httpdconf',
    notify    => Service['httpd'],
  }


# HTTP BackupPC.conf
  file  { '/etc/httpd/conf.d/BackupPC.conf':
    require   => Package['backuppc'],
    ensure    => present,
    source    => 'puppet:///modules/backuppc/httpbackupconf',
    notify    => Service['httpd'],
  }

# ssl.conf
  file  { '/etc/httpd/conf.d/ssl.conf':
    require   => Package['backuppc'],
    ensure    => present,
    content   => $SSLCONF,
    notify    => Service['httpd'],
  }

# BackupPC config.pl
  file  { '/etc/BackupPC/config.pl':
    require   => Package['backuppc'],
    ensure    => present,
    content   => $CONFIGPL,
    notify    => Service['backuppc'],
  }

# manage services
  service { 'backuppc':
    require   => File['/etc/BackupPC/config.pl'],
    enable    => true,
    ensure    => running,
  }

  service { 'httpd':
    require   => File['/etc/httpd/conf.d/BackupPC.conf'],
    enable    => true,
    ensure    => running,
  }
}
