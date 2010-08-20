dep 'cb admin group' do
  requires \
    'cb admin group exists',
    'cb admins can sudo'
end


dep 'cb admin group exists' do
  met? { grep /^admin\:/, '/etc/group' }
  meet { sudo 'groupadd admin' }
end

dep 'cb admins can sudo' do
  requires 'cb admin group exists'
  met? { !sudo('cat /etc/sudoers').split("\n").grep(/^%admin/).empty? }
  meet { append_to_file '%admin  ALL=(ALL) ALL', '/etc/sudoers', :sudo => true }
end
