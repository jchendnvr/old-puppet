class base::rootchange {
  require   addscripts

  exec  { 'rootchange':
    creates   => '/etc/example/checks/rootchange',
    command   => "/bin/echo '${ROOTPASS}' | /usr/bin/passwd --stdin root ; \
      /bin/touch /etc/example/checks/rootchange",
  }
}
