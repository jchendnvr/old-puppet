# Required Variables
# SSL Info
# $DORG='example'                    # O   Common Organization Name
# $DN                              # CN
# $DOU='IT'                        # OU, can be left at IT
# $DCOUNTRY='US'                   # C 
# $DSTATE='COLORADO'               # ST
# $DCITY='DENVER'                  # L 


class ssl {
  # create directories
  file { '/root/ssl':
    ensure    => directory,
    owner     => root,
    group     => root,
    mode      => 0700,
  }

  file { '/root/ssl/self':
    require   => File['/root/ssl'],
    ensure    => directory,
    owner     => root,
    group     => root,
    mode      => 0700,
  }

  file { '/root/ssl/ca':
    require   => File['/root/ssl'],
    ensure    => directory,
    owner     => root,
    group     => root,
    mode      => 0700,
  }

  # CSR
  exec { 'csr':
    require   => File['/root/ssl/ca'],
    command   => "/usr/bin/openssl req -new -sha256 -nodes -days 365 -newkey rsa:2048 -keyout /root/ssl/ca/${DN}.key -out /root/ssl/ca/${DN}.csr -subj \"/O=${DORG}/CN=${DN}/OU=${DOU}/C=${DCOUNTRY}/ST=${DSTATE}/L=${DCITY}/emailAddress=${DEMAIL}\"",
    unless    => '/bin/ls /root/ssl/ca/*csr',  
  }

  file { "/root/ssl/ca/${DN}.csr":
    require   => Exec['csr'],
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0400,
  }

  # Self
  exec { 'self':
    require   => File['/root/ssl/self'],
    command   => "/usr/bin/openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -keyout /root/ssl/self/${DN}.key -out /root/ssl/self/${DN}.crt -subj \"/O=$DORG/CN=${DN}/OU=${DOU}/C=${DCOUNTRY}/ST=$DSTATE/L=${DCITY}\"",
    unless    =>  '/bin/ls /root/ssl/self/*crt',
  }

  file { "/root/ssl/self/${DN}.crt":
    require   => Exec['self'],
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0400,
  }

  file { "/root/ssl/self/${DN}.key":
    require   => Exec['self'],
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0400,
  }

  # COPY SELF
  exec { 'copy_self_crt':
    require   => File["/root/ssl/self/${DN}.crt"],
    command   => "/bin/cp /root/ssl/self/${DN}.crt /etc/pki/tls/certs/",
    unless    => "/bin/ls /etc/pki/tls/certs/${DN}.crt",
  }

  exec { 'copy_self_key':
    require   => File["/root/ssl/self/${DN}.key"],
    command   => "/bin/cp /root/ssl/self/${DN}.key /etc/pki/tls/private/",
    unless    => "/bin/ls /etc/pki/tls/private/${DN}.key",
  }

  file { "/etc/pki/tls/certs/${DN}.crt":
    require   => Exec['copy_self_crt'],
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0400,
  }
  file { "/etc/pki/tls/private/${DN}.key":
    require   => Exec['copy_self_key'],
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => 0400,
  }
  
  # Create request.txt
  exec { 'create-request':
    require   => File["/root/ssl/ca/${DN}.csr"],
    command   => "/bin/cat /root/ssl/ca/${DN}.csr > /root/ssl/${DN}.request.txt",
    unless    => "/bin/ls /root/ssl/${DN}.request.txt",
  }

  # Gen dhparam > 2048bit
  exec  { 'gen_dhparam':
    require   => File['/root/ssl'],
    command   => '/usr/bin/openssl dhparam -out /root/ssl/dhparam.pem 2048 &',
    unless    => '/bin/ls /root/ssl/dhparam.pem',
  }
  
  exec { 'copy_dhparam':
    require   => Exec['gen_dhparam'],
    command   => '/bin/cp /root/ssl/dhparam.pem /etc/pki/tls/certs/',
    unless    => '/bin/ls /etc/pki/tls/certs/dhparam.pem',
  }



}

