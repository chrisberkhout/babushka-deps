dep 'site' do
  # requires 'system'
  requires \
    'account',
    'site dir',
    'rvm option'
    
  setup {
    define_var  :username, :message => 'Account username for this site?'
    define_var  :password, :message => 'Account password for this site?'
    define_var  :primary_domain, :message => 'Primary domain for this site (e.g. www.thesite.com)?'
  }
end


dep 'account' do
  met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
  meet {
    sudo 'adduser '+var(:username)+' --disabled-password --gecos ""'
    # Note that the crypted password is visible in process listings when running usermod,
    # as well as in the babushka logs of the user who ran it.
    # The password is entered as unmasked plain text into the terminal running babushka.
    range = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ./'
    salt = range.chars.to_a[rand(range.length)] + range.chars.to_a[rand(range.length)]
    sudo 'usermod -p '+var(:password).crypt(salt)+' '+var(:username)
  }
end

dep 'site dir' do
  requires 'account'
  met? { File.exist?('/home/'+var(:username)+'/'+var(:primary_domain)) }
  meet {
    sudo 'mkdir /home/'+var(:username)+'/'+var(:primary_domain)
    sudo 'chown '+var(:username)+':'+var(:username)+' /home/'+var(:username)+'/'+var(:primary_domain)
  }
end

