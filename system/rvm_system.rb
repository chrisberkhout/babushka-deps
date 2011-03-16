dep 'rvm system' do
  # http://rvm.beginrescueend.com/rvm/install/
  #
  # This does a system-wide (multi-user) rvm install. 
  #
  # System-wide rvm requires users to be in the rvm group to have write access.
  # This dep adds root and any admins to the rvm group. Also see the dep 'member of rvm'.
  # 
  # After installation, to use rvm immediately, without closing and restarting the shell, 
  # you need to use special subshells to ensure...
  #   that the shell environment is properly reloaded (`bash -lc "command"`), and
  #   that the new membership of the rvm group is active (`sg rvm -c "command"`). E.g.:
  #     `bash -lc "sg rvm -c \"rvm install ree-1.8.7-2010.02\""`          # install ree
  #     `bash -lc "sg rvm -c \"rvm --default use ree-1.8.7-2010.02\""`    # set ree as the system default ruby
  #
  # Gems will usually be installed into custom gemsets later, while setting up each account/project,
  # however, they can be installed without closing and restarting the shell, as follows:
  #     `bash -lc "sg rvm -c \"rvm ree-1.8.7-2010.02@default gem install rake\""`    # install into default gemset of given ruby
  #     `bash -lc "sg rvm -c \"rvm ree-1.8.7-2010.02 gemset create gemsetname\""`    # create new gemset for a given ruby
  #     `bash -lc "sg rvm -c \"rvm ree-1.8.7-2010.02@gemsetname gem install rake\""` # install into specific gemset of given ruby
  # Other variations may not work as expected and should be carefully tested.
  #
  requires \
    'curl',
    'build-essential',
    'apt rubygems',             # the rvm system-wide install script expects a system rubygems to exist
    #'sys libs for jruby',       # not needed unless using jruby
    #'sys libs for ironruby',    # not needed unless using ironruby
    'sys libs for mri and ree'

  met? { 
    # This works if system-wide rvm has been installed, even if the shell hasn't been closed and reopened.
    `bash -lc "rvm --version" 2>&1`[/rvm \d+\.\d+\.\d+ /] &&
    `bash -lc "env | grep ^rvm_path="`[/^rvm_path=\/usr\/local\/rvm$/] &&
    `bash -lc "type rvm | head -n1" 2>&1`[/^rvm is a function/] && 
    !changed_from_erb?('/usr/local/rvm/gemsets/default.gems', 'rvm_system/default.gems.erb') &&
    !changed_from_erb?('/usr/local/rvm/gemsets/global.gems', 'rvm_system/global.gems.erb')
  }
  meet {
    # clear any existing rvm environment variables, so the install goes into the default system-wide location.
    ENV.keys.select{ |k| !k[/^rvm_/].nil? }.each{ |k| ENV.delete(k) }

    shell "curl -L http://bit.ly/rvm-install-system-wide > /tmp/rvm-install-system-wide"
    sudo  "bash /tmp/rvm-install-system-wide"
    shell "rm /tmp/rvm-install-system-wide"
    
    my_render_erb "rvm_system/default.gems.erb", :to => '/usr/local/rvm/gemsets/default.gems', :sudo => true
    my_render_erb "rvm_system/global.gems.erb",  :to => '/usr/local/rvm/gemsets/global.gems',  :sudo => true

    line_to_add = "\n# RVM (Ruby Version Manager)\nif [[ -s /usr/local/lib/rvm ]] ; then source /usr/local/lib/rvm ; fi\n"
    # For login shells:
    if File.exist?("/etc/profile.d") then 
      sudo "echo \"#{line_to_add}\" > /etc/profile.d/rvm-system-wide.sh"
      sudo "chmod +x /etc/profile.d/rvm-system-wide.sh"
    elsif File.exist?("/etc/profile") then 
      sudo "echo \"#{line_to_add}\" >> /etc/profile" 
    end
    # For non-login shells: (prepend so that it runs before '[ -z "$PS1" ] && return' does an early return)
    sudo "echo \"#{line_to_add}\" | cat - /etc/bash.bashrc > /tmp/bash.bashrc.new && mv /tmp/bash.bashrc.new /etc/bash.bashrc" if File.exist?("/etc/bash.bashrc")
    
    sudo "usermod -aG rvm root" # Add root to the rvm group.
    members_of('admin').each { |u| sudo "usermod -aG rvm #{u}" } # Add admins to the rvm group

  }
end


dep 'apt rubygems' do
  met? { `dpkg -s rubygems 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install rubygems" }
end
  

dep 'sys libs for mri and ree' do
  # This is according to the RVM install instructions
  requires \
    'bison',             # defined elsewhere
    'openssl',
    'zlib1g-dev',
    'libreadline5-dev',
    'libssl-dev',
    'libsqlite3-dev',
    'sqlite3',
    'libxml2-dev',
    'libxslt1-dev',
    'extra sys libs for ruby-head'
end

dep 'extra sys libs for ruby-head' do
  requires \
    'subversion',
    'autoconf'
end


dep 'openssl' do
  met? { `dpkg -s openssl 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install openssl" }
end
dep 'zlib1g-dev' do
  met? { `dpkg -s zlib1g-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install zlib1g-dev" }
end
dep 'libreadline5-dev' do
  met? { `dpkg -s libreadline5-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libreadline5-dev" }
end
dep 'libssl-dev' do
  met? { `dpkg -s libssl-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libssl-dev" }
end
dep 'libsqlite3-dev' do
  met? { `dpkg -s libsqlite3-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libsqlite3-dev" }
end
dep 'sqlite3' do
  met? { `dpkg -s sqlite3 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install sqlite3" }
end
dep 'libxml2-dev' do
  met? { `dpkg -s libxml2-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libxml2-dev" }
end
dep 'subversion' do
  met? { `dpkg -s subversion 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install subversion" }
end
dep 'autoconf' do
  met? { `dpkg -s autoconf 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install autoconf" }
end
dep 'libxslt1-dev' do # needed by nokogiri, might as well install it with ruby
  met? { `dpkg -s libxslt1-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libxslt1-dev" }
end


dep 'sys libs for jruby' do
  requires 'java'
end


dep 'sys libs for ironruby' do
  requires 'mono-2.0-devel'
end

dep 'mono-2.0-devel' do
  met? { `dpkg -s mono-2.0-devel 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install mono-2.0-devel" }
end
