class base {
  include facts
  include base::disableipv6
  include base::epel_repo
  include base::stop_services
  include base::remove_packages
  include base::add_packages
  include base::bashrc
  include base::toprc
  include base::vim
  include base::vnstat
  include base::motd
  include addscripts
  include base::rootchange
  include ntpd
  include ntpd::timezone
  include ssh
  include ssl
}
