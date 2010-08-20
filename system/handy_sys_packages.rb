dep 'cb handy sys packages' do
  requires \
    'cb build-essential',
    'cb curl',
    'cb bison'
end


dep 'cb build-essential' do
  met? { `dpkg -s build-essential 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install build-essential" }
end

dep 'cb bison' do
  met? { `dpkg -s bison 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install bison" }
end

dep 'cb curl' do
  met? { `dpkg -s curl 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install curl" }
end
