dep 'cb user' do
  # requires 'cb system'
  requires \
    'cb account',
    'cb site dir',
    'cb rvm option'
    
  setup {
    define_var  :username, :message => 'Account username for this site?'
    define_var  :password, :message => 'Account password for this site?'
    define_var  :primary_domain, :message => 'Primary domain for this site (e.g. www.thesite.com)?'
  }
end
