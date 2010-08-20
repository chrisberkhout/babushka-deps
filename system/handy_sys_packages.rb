dep 'handy sys packages' do
  requires \
    'build-essential',
    'curl',
    'bison'
end


dep 'build-essential' do
  met? { `dpkg -s build-essential 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install build-essential" }
end

dep 'bison' do
  met? { `dpkg -s bison 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install bison" }
end

dep 'curl' do
  met? { `dpkg -s curl 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install curl" }
end
