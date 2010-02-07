dep 'system' do
  requires \
    'ubuntu karmic 9.10', # just because that's what I have been writing my deps on
    'ssh',
    'time setup',
    'build-essential'
    # 'rubygems deb',
    # 'rubygems handy gems'
end


dep 'ubuntu karmic 9.10' do
  met? { grep 'Ubuntu 9.10', '/etc/lsb-release' }
end

dep 'ssh' do
  met? { `dpkg -s openssh-server 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install openssh-server" }
end

dep 'build-essential' do
  met? { `dpkg -s build-essential 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install build-essential" }
end

dep 'rubygems' do # any version of rubygems
  met? { `gem -v 2>&1`[/^\d+\.\d+\.\d+$/] }
  # can meet using any of several different installation strategies
end
