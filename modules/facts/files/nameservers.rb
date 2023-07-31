# Gather the nameservers as custom fact

Facter.add('nameservers') do
  setcode '/bin/grep nameserver /etc/resolv.conf | cut -d \' \' -f2'
end
