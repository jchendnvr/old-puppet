# Required Variables
# $PHPV - phpversion simply as 5.3 or 5.5, etc
class ioncube {
  # ioncube loaders downloaded from
  # http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
  # see http://www.ioncube.com/loaders.php
 
  $INIFILE = "zend_extension = /usr/lib64/php/modules/ioncube_loader_lin_${PHPV}.so"
 
  include ::php55

  file  { "/usr/lib64/php/modules/ioncube_loader_lin_${PHPV}.so":
    #require    => Class['phpfpm'], 
    ensure    => present,
    source    => "puppet:///modules/ioncube/ioncube/ioncube_loader_lin_${PHPV}.so",
  }
  
  file  { '/etc/php.d/20-ioncube.ini':
    require   => File["/usr/lib64/php/modules/ioncube_loader_lin_${PHPV}.so"],
    ensure    => present,
    content   => $INIFILE,
    notify    => Service['php-fpm'],
  }
}
