dep 'cb user' do
  # requires 'cb system'
  requires \
    'cb account'

    # site dir
    # project
    
  setup { define_var  :username, :message => 'What is the user name?' }
end
