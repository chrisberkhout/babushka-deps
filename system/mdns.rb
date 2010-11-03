dep 'mdns' do
  # mDSN is Multicast DNS (for automatic 'hostname.local.' (note trailing dot) on the local network):
  #    http://en.wikipedia.org/wiki/Zero_configuration_networking
  #    http://en.wikipedia.org/wiki/Avahi_(software)
  requires 'avahi-daemon'
end

dep 'avahi-daemon' do
  met? { 
    `dpkg -s avahi-daemon 2>&1`.include?("\nStatus: install ok installed\n") &&
    `service avahi-daemon status 2>&1`.include?("avahi-daemon start/running")
  }
  meet { 
    sudo "apt-get -y install avahi-daemon"
    sudo "service avahi-daemon start"
  }
end
