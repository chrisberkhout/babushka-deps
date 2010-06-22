dep 'cb ssh server' do
  met? { `dpkg -s openssh-server 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install openssh-server" }
end
