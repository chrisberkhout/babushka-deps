dep 'authentication' do
  setup { set :user_dot_ssh_dir, "#{home_of(var :username)}/.ssh" }
  requires \
    '.ssh directory',
    'ssh key authorized'
end


dep '.ssh directory' do
  requires 'account with password'
  met? { 
    File.exist?(var(:user_dot_ssh_dir)) &&
    File.ftype(var(:user_dot_ssh_dir)) == "directory" &&
    owner_and_group?(var(:user_dot_ssh_dir), "#{var :username}:#{var :username}") &&
    perms?(var(:user_dot_ssh_dir), "700")
  }
  meet { 
    sudo "mkdir -p #{var(:user_dot_ssh_dir)}"
    sudo "chown #{var :username}:#{var :username} #{var(:user_dot_ssh_dir)}"
    sudo "chmod 700 #{var(:user_dot_ssh_dir)}"
  }
end

dep 'ssh key authorized' do
  requires \
    'account with password',
    '.ssh directory'
  met? { 
    `sudo ls #{var(:user_dot_ssh_dir)}/authorized_keys 2>&1`.match(%{^#{var(:user_dot_ssh_dir)}/authorized_keys}) &&
    `sudo ls -l #{var(:user_dot_ssh_dir)}/authorized_keys 2>&1`.match(%r{^-rw------- \d+ #{var :username} #{var :username} }) &&
    `sudo cat #{var(:user_dot_ssh_dir)}/authorized_keys 2>&1`.include?(var :ssh_key_to_authorize)
  }
  meet { 
    sudo "touch #{var(:user_dot_ssh_dir)}/authorized_keys"
    sudo "chown #{var :username}:#{var :username} #{var(:user_dot_ssh_dir)}/authorized_keys"
    sudo "chmod 600 #{var(:user_dot_ssh_dir)}/authorized_keys"
    sudo "echo \"#{var :ssh_key_to_authorize}\" >> #{var(:user_dot_ssh_dir)}/authorized_keys"
  }
end
