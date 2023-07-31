# example db use
# uses the mariadb::db define type to create a db called with a separateuser and pass
# Then all thats needed is the below in the site.pp
# $EXAMPLEDBPASS = 'Password123'
# include db::example
#
# creates /etc/example/checks/db-{$dbname}-db file

class db::example {
 mariadb::db { 'example':
    dbname    => 'example',
    dbuser    => 'example',
    dbpass    => $EXAMPEDBPASS,
 }
}
