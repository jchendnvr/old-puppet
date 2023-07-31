class remi {

# http://mirrors.kernel.org/fedora-epel/6/i386/repoview/epel-release.html

  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-remi':
    source    => 'puppet:///modules/remi/RPM-GPG-KEY-remi',
    ensure    => present,
  }   
  
  file { '/etc/yum.repos.d/remi.repo':
    source    => 'puppet:///modules/remi/remi.repo',
    ensure    => present,
    require   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-remi'],
  }

}

