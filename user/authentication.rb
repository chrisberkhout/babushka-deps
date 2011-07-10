dep 'authentication' do
  requires \
    '.ssh directory',
    'ssh key authorized'
end


dep '.ssh directory' do
  requires 'account with password'
  met? { 
    Dir.exist?("/#{var :username}/.ssh") &&
    owner_and_group?("/#{var :username}/.ssh", "#{var :username}:#{var :username}") &&
    perms?("/#{var :username}/.ssh", "700")
  }
  meet { 
    sudo "mkdir -p /#{var :username}/.ssh"
    sudo "chown #{var :username}:#{var :username} /#{var :username}/.ssh"
    sudo "chmod 700 /#{var :username}/.ssh"
  }
end

dep 'ssh key authorized' do
  requires \
    'account with password',
    '.ssh directory'
  met? { 
    File.exist?("/#{var :username}/.ssh/authorized_keys") &&
    owner_and_group?("/#{var :username}/.ssh/authorized_keys", "#{var :username}:#{var :username}") &&
    perms?("/#{var :username}/.ssh/authorized_keys", "600") &&
    grep(var(:ssh_key_to_authorize), "/#{var :username}/.ssh/authorized_keys")
  }
  meet { 
    sudo "touch /#{var :username}/.ssh/authorized_keys"
    sudo "chown #{var :username}:#{var :username} /#{var :username}/.ssh/authorized_keys"
    sudo "chmod 600 /#{var :username}/.ssh/authorized_keys"
    sudo "echo #{var :ssh_key_to_authorize} >> /#{var :username}/.ssh/authorized_keys"
  }
end
