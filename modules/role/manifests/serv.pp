# service type Serv
class role::serv {
  include base
  include hosts
  include iptables
  include nginx
  include phpfpm
  include mariadb
  include email::full
}
