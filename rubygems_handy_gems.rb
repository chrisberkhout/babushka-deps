dep 'rubygems handy gems' do
  requires \
    'rake'
end


dep 'rake' do
  requires 'rubygems'
  met? { `gem list rake`.include?('rake ') && `rake --version 2>&1`.include?('rake, version ') }
  meet { sudo "gem install rake" }
end

