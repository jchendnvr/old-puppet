class base::epel_repo {

# http://mirrors.kernel.org/fedora-epel/6/i386/repoview/epel-release.html

  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6':
    source    => 'puppet:///modules/base/RPM-GPG-KEY-EPEL-6',
    ensure    => present,
  }  
  
  file { '/etc/yum.repos.d/epel.repo':
    source    => 'puppet:///modules/base/epel.repo',
    ensure    => present,
    require   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6'],
  }

}
