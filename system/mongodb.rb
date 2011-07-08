dep 'mongodb' do
  # http://www.mongodb.org/display/DOCS/Ubuntu+and+Debian+packages
  requires \
    '10gen gpg key added',
    '10gen apt source added',
    'mongodb-10gen'
end

dep '10gen gpg key added' do
  met? { `sudo apt-key list`[/7F0CEB10/] }
  meet { sudo "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10" }
end

dep '10gen apt source added' do
  met? { 
    grep %r{^deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen$}, "/etc/apt/sources.list"
  }
  meet {
    append_to_file "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen", "/etc/apt/sources.list", :sudo => true
    sudo  "apt-get update"
    shell "touch ~/.ran_apt-get_update"
  }
end

dep 'mongodb-10gen' do
  requires 'apt-get update today' # may be needed to get the latest stable build
  met? { `dpkg -s mongodb-10gen 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install mongodb-10gen" }
end
