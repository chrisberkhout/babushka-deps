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

dep 'c1' do
  met? { File.exist?("/home/#{var :username}/.ssh/authorized_keys") }
end
dep 'c2' do
  met? { owner_and_group?("/home/#{var :username}/.ssh/authorized_keys", "#{var :username}:#{var :username}") }
end
dep 'c3' do
  met? { perms?("/home/#{var :username}/.ssh/authorized_keys", "600") }
end
dep 'c4' do
  met? { `sudo cat /home/#{var :username}/.ssh/authorized_keys`.include?(var :ssh_key_to_authorize) }
end

dep 'ssh key authorized' do
  requires \
    'c1', 'c2', 'c3', 'c4',
    'account with password',
    '.ssh directory'
  met? { 
    File.exist?("/home/#{var :username}/.ssh/authorized_keys") &&
    owner_and_group?("/home/#{var :username}/.ssh/authorized_keys", "#{var :username}:#{var :username}") &&
    perms?("/home/#{var :username}/.ssh/authorized_keys", "600") &&
    `sudo cat /home/#{var :username}/.ssh/authorized_keys`.include?(var :ssh_key_to_authorize)
  }
  meet { 
    sudo "touch /home/#{var :username}/.ssh/authorized_keys"
    sudo "chown #{var :username}:#{var :username} /home/#{var :username}/.ssh/authorized_keys"
    sudo "chmod 600 /home/#{var :username}/.ssh/authorized_keys"
    sudo "echo \"#{var :ssh_key_to_authorize}\" >> /home/#{var :username}/.ssh/authorized_keys"
  }
end
