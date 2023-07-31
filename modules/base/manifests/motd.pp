class base::motd {
  $motd = template('base/motd.erb')

  file { '/etc/motd':
    ensure  => present,
    replace => true,
    # source  => 'puppet:///modules/base/motd',
    # source  => $motd,
    content => $motd,
    mode    => 0644,
    owner   => root,
    group   => root,
  }
}
