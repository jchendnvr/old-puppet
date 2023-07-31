# Required Variables
# SSH - set to INTERNAL or CLIENT

class ssh {

# ssh keys for client and internal
# sshd config for client and internal
  case $SSH {
      'INTERNAL': {
        $SSHKEYS = 'authorized_keys_internal'
        $SSHDCONFIG = 'sshd_config_internal'
      }
      'CLIENT': {
        $SSHKEYS = 'authorized_keys_client'
        $SSHDCONFIG = 'sshd_config_client'
      }
  }
  

  # SSHD Configs 
  package { 'openssh':
    ensure  => present,
  }

  file { '/etc/ssh/sshd_config':
    require => Package['openssh'],
    notify  => Service['sshd'],
    source  => "puppet:///modules/ssh/${SSHDCONFIG}",
  }
  service { 'sshd':
    require => File['/etc/ssh/sshd_config'],
    enable  => true,
    ensure  => running,
  }

  # SSH authorized_keys
  file { '/root/.ssh/':
    ensure  => directory,     
    owner   => root,
    group   => root,
    mode    => 0700,
  }

  file { '/root/.ssh/authorized_keys':
    require => File['/root/.ssh/'],
    ensure  => present,
    source  => "puppet:///modules/ssh/${SSHKEYS}",
    replace => no,
  }  


}
