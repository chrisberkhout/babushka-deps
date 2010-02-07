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
    'rubygems deb bin dir in current path',
    'rubygems deb bin dir in secure path'
end


dep 'rubygems deb bin dir added to path in profile' do
  requires 'rubygems deb package installed'
  met? { File.exists?('/etc/profile.d/add_rubygems_deb_bin_dir_to_path.sh') }
  meet { 
    set :rubygems_deb_bin_dir, `gem env`.scan(/EXECUTABLE DIRECTORY: (.*)$/).first.first
    render_erb "rubygems_deb/add_rubygems_deb_bin_dir_to_path.sh.erb", :to => '/etc/profile.d/add_rubygems_deb_bin_dir_to_path.sh'
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

dep 'rubygems deb bin dir in secure path' do
  # with ubuntu/debian's rubygems this has to be done for sudo to be able to use gem executables (e.g. rake)
  requires 'rubygems deb package installed'
  met? { 
    dir = set :rubygems_deb_bin_dir, `gem env`.scan(/EXECUTABLE DIRECTORY: (.*)$/).first.first
    `sudo env`[/^PATH=.*#{dir}.*$/].is_a?(String)
  }
  meet { 
    current_path = `echo $PATH`.chomp
    new_path = current_path.include?(var :rubygems_deb_bin_dir) ? current_path : current_path+":"+var(:rubygems_deb_bin_dir)
    lines = File.new('/etc/sudoers').readlines
    lines.insert(lines.index("Defaults\tenv_reset\n")+1, "Defaults\tsecure_path=\"#{new_path}\"\n")
    while (File.exists?("/etc/sudoers.tmp")) do; puts "Waiting for /etc/sudoers.tmp"; sleep 1; end
    File.open('/etc/sudoers.tmp', 'w') { |f| f.write(lines.join) }
    File.chmod(0440, '/etc/sudoers.tmp')
    `cp /etc/sudoers /etc/sudoers.bak`
    # could do a check with visudo here to make sure that the new file can be parsed without errors... but it probably can.
    `mv /etc/sudoers.tmp /etc/sudoers`
  }
end
