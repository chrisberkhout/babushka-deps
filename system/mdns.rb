dep 'mdns' do
  # mDSN is Multicast DNS (for automatic 'hostname.local.' (note trailing dot) on the local network):
  #    http://en.wikipedia.org/wiki/Zero_configuration_networking
  #    http://en.wikipedia.org/wiki/Avahi_(software)
  requires 'avahi-daemon'
end

dep 'avahi-daemon' do
  requires \
    'avahi-daemon installed',
    'avahi-daemon configured'
end

dep 'avahi-daemon installed' do
  met? { `dpkg -s avahi-daemon 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install avahi-daemon" }
end

dep 'avahi-daemon configured' do
  # VMware doesn't seem to provide an IPv6 interface, so we don't want to publish AAAA (IPv6) records.
  # Without this change `ssh -vvv user@guesthostname.local.` times out on a IPv6 attempt before using IPv4.
  met? { grep /^publish\-aaaa\-on\-ipv4\=no$/, '/etc/avahi/avahi-daemon.conf' }
  meet { 
    change_line '#publish-aaaa-on-ipv4=yes', 'publish-aaaa-on-ipv4=no', '/etc/avahi/avahi-daemon.conf' 
    sudo "service avahi-daemon restart"
  }
end
