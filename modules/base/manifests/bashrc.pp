class base::bashrc {
  file { '/etc/bashrc':
    ensure  => present,
    source  => 'puppet:///modules/base/bashrc',
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
  }
  file { '/root/.bashrc':
    require => File['/etc/bashrc'],
    ensure  => present,
    source  => 'puppet:///modules/base/bashrcuser',
    owner   => 'root',
    group   => 'root',
    mode    => 0600,
  }


}
