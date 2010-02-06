dep 'rubygems handy gems' do
  requires \
    'rake'
end


dep 'rake' do
  requires 'rubygems'
  met? { 
    set :rubygems_deb_bin_dir, `gem env`.scan(/EXECUTABLE DIRECTORY: (.*)$/).first.first
    ENV['PATH'].include?(var :rubygems_deb_bin_dir)
    `rake --version 2>&1`.include?('rake, version ') 
  }
  # met? { `gem list rake`.include?('rake ') && `rake --version 2>&1`.include?('rake, version ') }
  # meet { sudo "gem install rake" }
end
