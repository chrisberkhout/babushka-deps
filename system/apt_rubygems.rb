# This installs the Ubuntu/Debian version of rubygems via apt-get. Building from source is preferred.
# This version has 'gem update --system' diabled.
# It doesn't create wrappers for gem executables in /usr/bin, so the gem 'EXECUTABLE DIRECTORY' needs to be added to the paths.

dep 'cb apt rubygems' do
  requires \
    'cb apt rubygems package installed',
    'cb apt rubygems path setup'
end


dep 'cb apt rubygems package installed' do
  met? { `dpkg -s rubygems 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { 
    sudo "apt-get -y install rubygems"
  }
end

dep 'cb apt rubygems path setup' do
  requires \
    'cb apt rubygems bin dir added to path in profile',
    'cb apt rubygems bin dir in secure path',
    'cb apt rubygems bin dir in current path'
end


dep 'cb apt rubygems bin dir added to path in profile' do
  requires 'cb apt rubygems package installed'
  met? { File.exists?('/etc/profile.d/add_apt_rubygems_bin_dir_to_path.sh') }
  meet { 
    set :apt_rubygems_bin_dir, `gem env`.scan(/EXECUTABLE DIRECTORY: (.*)$/).first.first
    render_erb "apt_rubygems/add_apt_rubygems_bin_dir_to_path.sh.erb", :to => '/etc/profile.d/add_apt_rubygems_bin_dir_to_path.sh', :sudo => true
    sudo "chmod +x /etc/profile.d/add_apt_rubygems_bin_dir_to_path.sh"
  }
end

dep 'cb apt rubygems bin dir in current path' do
  requires 'cb apt rubygems package installed'
  met? { 
    set :apt_rubygems_bin_dir, `gem env`.scan(/EXECUTABLE DIRECTORY: (.*)$/).first.first
    ENV['PATH'].include?(var :apt_rubygems_bin_dir)
  }
  meet { 
    ENV['PATH'] = ENV['PATH'] + ':' + var(:apt_rubygems_bin_dir)
  }
end

dep 'cb apt rubygems bin dir in secure path' do
  # With Ubuntu/Debian's rubygems this has to be done for sudo to be able to use gem executables (e.g. rake).
  # This only works on ubuntu karmic or later.
  requires 'cb apt rubygems package installed'
  met? { 
    dir = set :apt_rubygems_bin_dir, `gem env`.scan(/EXECUTABLE DIRECTORY: (.*)$/).first.first
    `sudo env`[/^PATH=.*#{dir}.*$/].is_a?(String)
  }
  meet { 
    current_path = `echo $PATH`.chomp
    new_path = current_path.include?(var :apt_rubygems_bin_dir) ? current_path : current_path+":"+var(:apt_rubygems_bin_dir)
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
