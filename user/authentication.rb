dep 'authentication' do
  requires \
    '.ssh directory',
    'ssh key authorized'
end


dep '.ssh directory' do
  requires 'account with password'
  met? { 
    File.exist?("/home/#{var :username}/.ssh") &&
    File.ftype("/home/#{var :username}/.ssh") == "directory" &&
    owner_and_group?("/home/#{var :username}/.ssh", "#{var :username}:#{var :username}") &&
    perms?("/home/#{var :username}/.ssh", "700")
  }
  meet { 
    sudo "mkdir -p /home/#{var :username}/.ssh"
    sudo "chown #{var :username}:#{var :username} /home/#{var :username}/.ssh"
    sudo "chmod 700 /home/#{var :username}/.ssh"
  }
end

dep 'ssh key authorized' do
  requires \
    'account with password',
    '.ssh directory'
  met? { 
    `sudo ls /home/#{var :username}/.ssh/authorized_keys`.match(%{^/home/#{var :username}/.ssh/authorized_keys}) &&
    `sudo ls -l /home/#{var :username}/.ssh/authorized_keys`.match(%r{^-rw------- \d+ #{var :username} #{var :username} }) &&
    `sudo cat /home/#{var :username}/.ssh/authorized_keys`.include?(var :ssh_key_to_authorize)
  }
  meet { 
    sudo "touch /home/#{var :username}/.ssh/authorized_keys"
    sudo "chown #{var :username}:#{var :username} /home/#{var :username}/.ssh/authorized_keys"
    sudo "chmod 600 /home/#{var :username}/.ssh/authorized_keys"
    sudo "echo \"#{var :ssh_key_to_authorize}\" >> /home/#{var :username}/.ssh/authorized_keys"
  }
end
