dep 'admin group' do
  requires \
    'admin group exists',
    'admins can sudo'
end


dep 'admin group exists' do
  met? { grep /^admin\:/, '/etc/group' }
  meet { sudo 'groupadd admin' }
end

dep 'admins can sudo' do
  requires 'admin group exists'
  met? { !`echo && sudo -u root cat /etc/sudoers`.split("\n").grep(/^%admin/).empty? }
  meet { append_to_file '%admin  ALL=(ALL) ALL', '/etc/sudoers', :sudo => true }
end
