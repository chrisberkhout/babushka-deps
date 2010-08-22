dep 'rvm user' do
  # http://rvm.beginrescueend.com/rvm/install/
  #
  # This installs rvm for the current user only. According to rvm deployment best practices, system-wide install is better:
  #   http://rvm.beginrescueend.com/deployment/best-practices/
  #
  # With system-wide + user installs, http://rvm.beginrescueend.com/deployment/system-wide/ says
  #   "you need to edit ~/.rvmrc to manually override the path values set in /etc/rvmrc", but
  #   it looks like this is already handled with an if clause in /etc/rvmrc.
  #
  # Getting rvm to be used by non-user stuff like passenger is tricky:
  #   http://rvm.beginrescueend.com/integration/passenger/
  #   (discussion of upcoming multiple rubies support) http://bit.ly/8ZMLzg

  requires \
    'curl',                     # defined elsewhere
    'build-essential',          # defined elsewhere
    #'sys libs for jruby',       # not needed unless using jruby
    #'sys libs for ironruby',    # not needed unless using ironruby (may not be working yet: )
    'sys libs for mri and ree',
    'sys libs for ruby'         # defined elsewhere

  met? { 
    # This works if rvm has been installed, even if the shell hasn't been closed and reopened
    File.exist?(File.expand_path("~/.rvm/scripts/rvm")) && `bash -lc "rvm --version" 2>&1`[/rvm \d+\.\d+\.\d+ /]
  }
  meet {
    username = `whoami`.chomp
    
    shell "mkdir -p ~/.rvm/src/"
    Dir.chdir(File.expand_path("~/.rvm/src"))
    shell "rm -rf ./rvm/"
    shell "git clone git://github.com/wayneeseguin/rvm.git"
    Dir.chdir "rvm"
    shell "./install"

    line_to_add = "\n# RVM (Ruby Version Manager)\nif [[ -s /home/#{username}/.rvm/scripts/rvm ]] ; then source /home/#{username}/.rvm/scripts/rvm ; fi\n"
    shell "echo \"#{line_to_add}\" >> ~/.profile" if File.exist?(File.expand_path("~/.profile"))
    shell "echo \"#{line_to_add}\" >> ~/.bash_profile" if File.exist?(File.expand_path("~/.bash_profile"))
    # Prepend to .bashrc so that it runs before '[ -z "$PS1" ] && return' does the early return for non-interactive sessions
    shell "echo \"#{line_to_add}\" | cat - ~/.bashrc > ~/.bashrc.new && mv ~/.bashrc.new ~/.bashrc" if File.exist?(File.expand_path("~/.bashrc"))
    
    # To use rvm without closing and restarting the shell, run the command in a bash -lc subshell
    # and suck relevant environment variables up into the current environment. e.g:
    ruby_vars = ['PATH','GEM_HOME','GEM_PATH','BUNDLE_PATH','MY_RUBY_HOME','IRBRC','RUBYOPT','gemset','MANPATH']
    suck_env(`bash -lc "rvm --default system; echo; env"`, ruby_vars)
    
  }
end


dep 'sys libs for mri and ree' do
  # this is according to the RVM install instructions
  requires \
    'libssl-dev',        # defined elsewhere
    'libreadline5-dev',  # defined elsewhere
    'zlib1g-dev',        # defined elsewhere
    'build-essential',   # defined elsewhere
    'bison',             # defined elsewhere
    'libxml2-dev'
end

dep 'libxml2-dev' do
  met? { `dpkg -s libxml2-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libxml2-dev" }
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
