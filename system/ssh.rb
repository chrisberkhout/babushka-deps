dep 'ssh server' do
  met? { `dpkg -s openssh-server 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install openssh-server" }
end

dep 'ssh gateway ports enabled' do
  met? { grep /^GatewayPorts\s+yes/, "/etc/ssh/sshd_config" }
  meet { append_to_file "GatewayPorts yes", "/etc/ssh/sshd_config", :sudo => true }
end
