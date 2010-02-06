# This installs the Ubuntu/Debian version of rubygems via apt-get.
# This version has 'gem update --system' diabled.
# It doesn't create wrappers for gem executables in /usr/bin, so the gem 'EXECUTABLE DIRECTORY' needs to be added to the path.

dep 'rubygems deb' do
  requires \
    'rubygems deb package installed',
    'rubygems deb path setup'
end


dep 'rubygems deb package installed' do
  met? { `dpkg -s rubygems 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { 
    sudo "apt-get -y install rubygems"
  }
end

dep 'rubygems deb path setup' do
  requires \
    'rubygems deb bin dir added to path in profile',
    'rubygems deb bin dir in current path'
end


dep 'rubygems deb bin dir added to path in profile' do
  requires 'rubygems deb package installed'
  met? { File.exists?('/etc/profile.d/add_rubygems_bin_dir_to_path.sh') }
  meet { 
    set :rubygems_deb_bin_dir, `gem env`.scan(/EXECUTABLE DIRECTORY: (.*)$/).first.first
    render_erb "rubygems/add_rubygems_deb_bin_dir_to_path.sh.erb", :to => '/etc/profile.d/add_rubygems_deb_bin_dir_to_path.sh'
    shell "chmod +x /etc/profile.d/add_rubygems_deb_bin_dir_to_path.sh"
  }
end

dep 'rubygems deb bin dir in current path' do
  requires 'rubygems deb package installed'
  met? { 
    set :rubygems_deb_bin_dir, `gem env`.scan(/EXECUTABLE DIRECTORY: (.*)$/).first.first
    ENV['PATH'].include?(var :rubygems_deb_bin_dir)
  }
  meet { 
    ENV['PATH'] = ENV['PATH'] + var(:rubygems_deb_bin_dir)
  }
end
