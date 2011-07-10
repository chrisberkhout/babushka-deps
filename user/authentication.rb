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
    File.exist?("/home/#{var :username}/.ssh/authorized_keys") &&
    owner_and_group?("/home/#{var :username}/.ssh/authorized_keys", "#{var :username}:#{var :username}") &&
    perms?("/home/#{var :username}/.ssh/authorized_keys", "600") &&
    `sudo cat /home/#{var :username}/.ssh/authorized_keys`.include?(var :username)
  }
  meet { 
    sudo "touch /home/#{var :username}/.ssh/authorized_keys"
    sudo "chown #{var :username}:#{var :username} /home/#{var :username}/.ssh/authorized_keys"
    sudo "chmod 600 /home/#{var :username}/.ssh/authorized_keys"
    sudo "echo \"#{var :ssh_key_to_authorize}\" >> /home/#{var :username}/.ssh/authorized_keys"
  }
end
