dep 'cb user' do
  # requires 'cb system'
  requires \
    'cb account'



    # 'cb site dir',
    # 'cb rvm option'
    
  setup {
    define_var  :username, :message => 'Account username for this site?'
  }
end
