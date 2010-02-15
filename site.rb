dep 'site' do
  # requires 'system'
  requires 'account'
  requires 'site dir'
  # requires 'rvm user'
  
  setup {
    define_var  :username, :message => 'Account username for this site?'
    # ask_for_var :username.to_s
    
    define_var  :password, :message => 'Account password for this site?'
    # ask_for_var :password.to_s
    
    define_var  :primary_domain, :message => 'Primary domain for this site (e.g. www.thesite.com)?'
    # ask_for_var :primary_domain.to_s
    
    # define_var :install_rvm,
    #   :message => "System ruby is \""+`ruby -v 2>&1`.chomp+"\" do you want to install your own in an RVM?",
    #   :choices => ['yes', 'no'],
    #   :default => 'no'
    # ask_for_var :install_rvm.to_s
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

