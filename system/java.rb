dep 'java' do
  requires 'java6'
end

dep 'java6' do
  requires \
    'sun-java6-jre',
    'sun-java6-jdk'
end

dep 'sun-java6-jre' do
  # This will also install the architecture dependent files in sun-java6-bin.
  # License acceptance automation: http://wiki.debian.org/JavaFAQ
  requires 'canonical partner apt source added'
  met? { `dpkg -s sun-java6-jre 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "echo sun-java6-jre shared/accepted-sun-dlj-v1-1 boolean true | debconf-set-selections && apt-get -y install sun-java6-jre" }
end

dep 'sun-java6-jdk' do
  # License acceptance automation: http://wiki.debian.org/JavaFAQ
  requires 'canonical partner apt source added'
  met? { `dpkg -s sun-java6-jdk 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "echo sun-java6-jdk shared/accepted-sun-dlj-v1-1 boolean true | debconf-set-selections && apt-get -y install sun-java6-jdk" }
end
