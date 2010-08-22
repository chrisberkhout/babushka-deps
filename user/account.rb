dep 'account' do
  requires \
    'account with password',
    'member of admin',
    'member of rvm if it exists'
end


dep 'account with password' do
  met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
  meet { `adduser #{var(:username)} --gecos ""` }
end

dep 'member of admin' do
  requires 'admin group'
  met? { shell("groups #{var(:username)}")[/\badmin\b/] }
  meet { sudo "usermod -aG admin #{var(:username)}" }
end

dep 'member of rvm if it exists' do
  met? { `cat /etc/group | grep ^rvm:`.empty? || shell("groups #{var(:username)}")[/\brvm\b/] }
  meet { sudo "usermod -aG rvm #{var(:username)}" }
end
