class base::toprc {
  file { '/root/.toprc':
    ensure  => present,
    source  => 'puppet:///modules/base/toprc',
    owner   => root,
    group   => root,
    mode    => 0600,
  }
}
