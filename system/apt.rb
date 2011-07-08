dep 'apt-get update today' do
  met? { 
    File.exists?(File.expand_path("~/.ran_apt-get_update")) &&
    (Time.now - File.stat(File.expand_path("~/.ran_apt-get_update")).mtime) < 24*60*60 
  }
  meet { 
    sudo  "apt-get update"
    shell "touch ~/.ran_apt-get_update"
  }
end

dep 'canonical partner apt source added' do
  requires 'ubuntu lucid 10.04'
  met? { 
    grep %r{^deb http://archive.canonical.com/ lucid partner$}, "/etc/apt/sources.list"
  }
  meet {
    append_to_file "deb http://archive.canonical.com/ lucid partner", "/etc/apt/sources.list", :sudo => true
    sudo  "apt-get update"
    shell "touch ~/.ran_apt-get_update"
  }
end
