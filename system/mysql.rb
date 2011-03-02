dep 'mysql' do
  requires \
    'mysql-server-5.1',
    'libmysqlclient15-dev'
end

dep 'mysql-server-5.1' do
  met? { `dpkg -s mysql-server-5.1 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "env DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server-5.1" }
end

dep 'libmysqlclient15-dev' do
  met? { `dpkg -s libmysqlclient15-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libmysqlclient15-dev" }
end
