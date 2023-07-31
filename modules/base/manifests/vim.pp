class base::vim { 
  # vim-common, vim-enhanced, vim-filesystem, vim-nerdtree

  package { 'vim-common':
    ensure    => present,
 }

  package { 'vim-enhanced':
    ensure    => present,
 }

#  package { 'vim-filesystem':
#    require   => File['/etc/yum.repos.d/epel.repo'],
#    ensure    => present,
# }

#  package { 'vim-nerdtree':
#    require   => File['/etc/yum.repos.d/epel.repo'],
#    ensure    => present,
# }



  file { '/root/.vimrc':
    name      => $vimpackages,
     require  => Package['vim-enhanced'],
     replace  => true,  
     source   => 'puppet:///modules/base/vimrc',
     owner    => 'root',
     group    => 'root',
     mode     => 0600,
  }

}
