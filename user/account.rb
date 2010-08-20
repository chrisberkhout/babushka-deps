dep 'cb account' do
  requires \
    'cb account with password',
    'cb member of admin'
end


dep 'cb account with password' do
  met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
  meet { sudo "adduser #{var(:username)} --gecos \"\"" }
end

dep 'cb member of admin' do
  requires 'cb admin group'
  met? { shell("groups #{var(:username)}")[/\badmin\b/] }
  meet { sudo "usermod -a -G admin #{var(:username)}" }
end
