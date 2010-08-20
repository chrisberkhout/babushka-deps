dep 'user' do
  # requires 'system'
  requires \
    'account'

    # site dir
    # project
    
  setup { define_var  :username, :message => 'What is the user name?' }
end
