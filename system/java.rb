dep 'cb java6' do
  requires \
    'cb sun-java6-bin',
    'cb sun-java6-jre',
    'cb sun-java6-jdk'
end

dep 'cb sun-java6-bin' do
  met? { `dpkg -s sun-java6-bin 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install sun-java6-bin" }
end

dep 'cb sun-java6-jre' do
  met? { `dpkg -s sun-java6-jre 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install sun-java6-jre" }
end

dep 'cb sun-java6-jdk' do
  met? { `dpkg -s sun-java6-jdk 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install sun-java6-jdk" }
end
