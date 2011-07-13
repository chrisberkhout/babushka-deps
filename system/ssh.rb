dep 'ssh server' do
  met? { `dpkg -s openssh-server 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install openssh-server" }
end

dep 'ssh gateway ports enabled' do
  # This makes it possible to open forwarded ports on all interfaces instead of just loopback.
  # See "RemoteForward" in: http://souptonuts.sourceforge.net/sshtips.htm
  met? { grep /^GatewayPorts\s+yes/, "/etc/ssh/sshd_config" }
  meet { 
    append_to_file "GatewayPorts yes", "/etc/ssh/sshd_config", :sudo => true 
    sudo "/etc/init.d/ssh restart"
  }
end
