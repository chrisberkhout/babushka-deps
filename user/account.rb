dep 'cb account' do
  requires 'cb account with password'
end

dep 'cb account with password' do
  met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
  meet { `sudo adduser #{var(:username)} --gecos ""` }
end
