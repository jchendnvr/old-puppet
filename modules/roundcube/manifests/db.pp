# Required Variable
# $ROUNDCUBEDBPASS
#

class roundcube::db {
 mariadb::db { 'roundcube':
    dbname    => 'roundcube',
    dbuser    => 'roundcube',
    dbpass    => $ROUNDCUBEDBPASS,
 }
}
