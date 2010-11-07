dep 'account' do
  requires \
    'account with password',
    'member of admin',
    'member of rvm'
end


dep 'account with password' do
  met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
  meet { `sudo adduser #{var(:username)} --gecos ""`[/password updated successfully/] }
end

dep 'member of admin' do
  requires 'admin group'
  met? { members_of('admin').include?(var :username) }
  meet { sudo "usermod -aG admin #{var :username}" }
end

dep 'member of rvm' do
  # This will ensure the existance of the rvm group and :username's membership, even if system-wide rvm hasn't been installed.
  requires 'rvm group'
  met? { members_of('rvm').include?(var :username) }
  meet { sudo "usermod -aG rvm #{var :username}" }
end
