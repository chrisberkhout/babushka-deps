dep 'rvm system' do
  # http://rvm.beginrescueend.com/rvm/install/
  #
  # This does a system-wide (multi-user) rvm install. 
  #
  # For .rvmrc issues, see: http://serverfault.com/questions/227510/is-it-possible-to-skip-rvmrc-confirmation
  #
  # System-wide rvm requires users to be in the rvm group to have write access.
  # This dep adds root and any admins to the rvm group. Also see the dep 'member of rvm'.
  # 
  # After installation, to use rvm immediately, without closing and restarting the shell, 
  # you need to use special subshells to ensure...
  #   that the shell environment is properly reloaded (`bash -lc "command"`), and
  #   that the new membership of the rvm group is active (`sg rvm -c "command"`). E.g.:
  #     `bash -lc "sg rvm -c \"rvm install ruby-1.9.2-p180\""`          # install a ruby
  #     `bash -lc "sg rvm -c \"rvm --default use ruby-1.9.2-p180\""`    # set it as the system default ruby
  #
  # Gems may be installed into custom gemsets later, while setting up each account/project,
  # however, they can be installed without closing and restarting the shell, as follows:
  #     `bash -lc "sg rvm -c \"rvm ruby-1.9.2-p180@default gem install rake\""`    # install into default gemset of given ruby
  #     `bash -lc "sg rvm -c \"rvm ruby-1.9.2-p180 gemset create gemsetname\""`    # create new gemset for a given ruby
  #     `bash -lc "sg rvm -c \"rvm ruby-1.9.2-p180@gemsetname gem install rake\""` # install into specific gemset of given ruby
  # Other variations may not work as expected and should be carefully tested.
  #
  requires \
    'curl',
    'build-essential',
    'apt rubygems',             # the rvm system-wide install script expects a system rubygems to exist
    #'sys libs for jruby',       # not needed unless using jruby
    #'sys libs for ironruby',    # not needed unless using ironruby
    'sys libs for mri and ree',
    'gemrc'

  met? { 
    # This works if system-wide rvm has been installed, even if the shell hasn't been closed and reopened.
    `bash -lc "rvm --version" 2>&1`[/rvm \d+\.\d+\.\d+ /] &&
    `bash -lc "env | grep ^rvm_path="`[/^rvm_path=\/usr\/local\/rvm$/] &&
    `bash -lc "type rvm | head -n1" 2>&1`[/^rvm is a function/] && 
    !changed_from_erb?('/usr/local/rvm/gemsets/default.gems', 'rvm_system/default.gems.erb') &&
    !changed_from_erb?('/usr/local/rvm/gemsets/global.gems', 'rvm_system/global.gems.erb') &&
    File.exist?("/etc/profile.d/rvm.sh") &&
    grep(%r{source /etc/profile\.d/rvm\.sh}, "/etc/bash.bashrc")
  }
  meet {
    # clear any existing rvm environment variables, so the install goes into the default system-wide location.
    ENV.keys.select{ |k| !k[/^rvm_/].nil? }.each{ |k| ENV.delete(k) }

    shell "curl -L https://rvm.beginrescueend.com/install/rvm > /tmp/rvm-install-script"
    sudo  "bash /tmp/rvm-install-script"
    shell "rm /tmp/rvm-install-script"
    
    my_render_erb "rvm_system/default.gems.erb", :to => '/usr/local/rvm/gemsets/default.gems', :sudo => true
    my_render_erb "rvm_system/global.gems.erb",  :to => '/usr/local/rvm/gemsets/global.gems',  :sudo => true

    # Login shells are now set up by the RVM install script itself (via /etc/profile.d/rvm.sh)
    # For non-login shells: (prepend so that it runs before '[ -z "$PS1" ] && return' does an early return)
    unless grep(%r{source /etc/profile\.d/rvm\.sh}, "/etc/bash.bashrc")
      line_to_add = "\n# RVM (Ruby Version Manager)\nif [[ -s /etc/profile.d/rvm.sh ]] ; then source /etc/profile.d/rvm.sh ; fi\n"
      sudo "echo \"#{line_to_add}\" | cat - /etc/bash.bashrc > /tmp/bash.bashrc.new && mv /tmp/bash.bashrc.new /etc/bash.bashrc"
    end
    
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
    'libreadline6-dev',
    'libssl-dev',
    'libyaml-dev',
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
dep 'libreadline6-dev' do
  met? { `dpkg -s libreadline6-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libreadline6-dev" }
end
dep 'libssl-dev' do
  met? { `dpkg -s libssl-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libssl-dev" }
end
dep 'libyaml-dev' do
  met? { `dpkg -s libyaml-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libyaml-dev" }
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


dep 'gemrc' do
  met? { !changed_from_erb?('/etc/gemrc', 'rvm_system/etc_gemrc.erb') }
  meet { my_render_erb "rvm_system/etc_gemrc.erb", :to => '/etc/gemrc', :sudo => true }
end
