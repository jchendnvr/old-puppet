# REQUIRED VARIABLES
# DBNAME
# DBUSER
# DBPASS
# ROOTDBPASS

define mariadb::db ( $dbname, $dbuser, $dbpass ){
  exec { "create-${dbname}-db":
    creates    => "/etc/example/checks/db-${dbname}-db",
    command   => "/usr/bin/mysql -uroot -p${ROOTDBPASS} -e \"CREATE DATABASE ${dbname};
              GRANT ALL PRIVILEGES ON ${dbname}.* to '${dbuser}'@'localhost' IDENTIFIED BY '${dbpass}';\";
              /bin/touch /etc/example/checks/db-${dbname}-db"
  }
}
