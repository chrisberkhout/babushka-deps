dep 'system' do
  requires \
    'ubuntu karmic 9.10', # just because that's what I have been writing my deps on
    'time setup',
    'ssh server',
    'handy sys packages',
    'ruby',
    'rubygems',
    'rubygems handy sys gems',
    'nginx'
  
end


dep 'ubuntu karmic 9.10' do
  met? { grep 'Ubuntu 9.10', '/etc/lsb-release' }
end

dep 'ssh server' do
  met? { `dpkg -s openssh-server 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install openssh-server" }
end
