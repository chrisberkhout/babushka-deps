dep 'java6' do
  requires \
    'sun-java6-bin',
    'sun-java6-jre',
    'sun-java6-jdk'
end

dep 'sun-java6-bin' do
  met? { `dpkg -s sun-java6-bin 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install sun-java6-bin" }
end

dep 'sun-java6-jre' do
  met? { `dpkg -s sun-java6-jre 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install sun-java6-jre" }
end

dep 'sun-java6-jdk' do
  met? { `dpkg -s sun-java6-jdk 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install sun-java6-jdk" }
end
