dep 'account' do
  requires \
    'account with password',
    'member of admin'
end


dep 'account with password' do
  met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
  meet { sudo "adduser #{var(:username)} --gecos \"\"" }
end

dep 'member of admin' do
  requires 'admin group'
  met? { shell("groups #{var(:username)}")[/\badmin\b/] }
  meet { sudo "usermod -a -G admin #{var(:username)}" }
end
