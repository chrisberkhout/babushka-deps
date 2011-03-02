dep 'apt-get update today' do
  met? { 
    File.exists?(File.expand_path("~/.ran_apt-get_update")) &&
    (Time.now - File.stat(File.expand_path("~/.ran_apt-get_update")).mtime) < 24*60*60 
  }
  meet { 
    sudo  "apt-get update && "
    shell "touch ~/.ran_apt-get_update"
  }
end
