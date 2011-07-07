dep 'handy sys packages' do
  requires \
    'build-essential',
    'lsb-base',
    'curl',
    'bison',
    'imagemagick',
    'libmagickcore-dev',
    'libmagickwand-dev'
end


dep 'build-essential' do
  met? { `dpkg -s build-essential 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install build-essential" }
end

dep 'bison' do
  met? { `dpkg -s bison 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install bison" }
end

dep 'lsb-base' do
  met? { `dpkg -s lsb-base 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install lsb-base" }
end

dep 'curl' do
  met? { `dpkg -s curl 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install curl" }
end

dep 'imagemagick' do
  met? { `dpkg -s imagemagick 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install imagemagick" }
end
dep 'libmagickcore-dev' do
  met? { `dpkg -s libmagickcore-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libmagickcore-dev" }
end
dep 'libmagickwand-dev' do
  met? { `dpkg -s libmagickwand-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libmagickwand-dev" }
end
