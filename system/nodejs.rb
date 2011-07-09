dep "nodejs" do
  # https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
  # https://github.com/joyent/node/wiki/Installation
  requires \
    "python-software-properties",
    "apt source chris-lea-node.js-lucid.list added",
    "nodejs deb"
end


dep "python-software-properties" do
  met? { `dpkg -s python-software-properties 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install python-software-properties" }
end

dep "apt source chris-lea-node.js-lucid.list added" do
  requires "python-software-properties"
  met? { File.exist?("/etc/apt/sources.list.d/chris-lea-node.js-lucid.list") }
  meet {
    sudo "add-apt-repository ppa:chris-lea/node.js"
    sudo "apt-get update"
    shell "touch ~/.ran_apt-get_update"
  }
end

dep "nodejs deb" do
  requires "apt source chris-lea-node.js-lucid.list added"
  met? { `dpkg -s nodejs 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install nodejs" }
end
