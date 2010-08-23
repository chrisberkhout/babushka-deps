dep 'rvm system' do
  # 'rvm system' has PROBLEMS ('rvm user' seems okay). See met?{} for details.
  #
  # http://rvm.beginrescueend.com/rvm/install/
  #
  # This does a system-wide (multi-user) rvm install. 
  # Individual users can additionally have their own user installations.
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
    #'sys libs for ironruby',    # not needed unless using ironruby
    'sys libs for mri and ree',
    'sys libs for ruby'         # defined elsewhere

  met? { 
    # This works if rvm has been installed, even if the shell hasn't been closed and reopened
    File.exist?(File.expand_path("/usr/local/lib/rvm")) && 
    `sudo bash -lc "rvm --version" 2>&1`[/rvm \d+\.\d+\.\d+ /]
    # Problems with 'rvm system':
    # 1) Setting a default ruby puts a script in /usr/local/bin/ruby to load the appropriate environment and
    #    exec the chosen ruby, but it seems to cause an infinite loop that ends with the error message:
    #    'exec: 12: gem: Argument list too long'.
    # 2) It is not clear that rvm can be used immediately after install, as /etc/groups isn't reread 
    #    until the next login.
  }
  meet {
    # clear any existing rvm environment variables, so the install goes into the default system-wide location.
    ENV.keys.select{ |k| !k[/^rvm_/].nil? }.each{ |k| ENV.delete(k) }

    sudo "curl -L http://bit.ly/rvm-install-system-wide > /tmp/rvm-install-system-wide"
    sudo "bash /tmp/rvm-install-system-wide"
    sudo "rm /tmp/rvm-install-system-wide"

    line_to_add = "\n# RVM (Ruby Version Manager)\nif [[ -s /usr/local/lib/rvm ]] ; then source /usr/local/lib/rvm ; fi\n"
    # For login shells:
    if File.exist?("/etc/profile.d")  then sudo "echo \"#{line_to_add}\" > /etc/profile.d/rvm-system-wide.sh" 
    elsif File.exist?("/etc/profile") then sudo "echo \"#{line_to_add}\" >> /etc/profile" 
    end
    # For non-login shells: (prepend so that it runs before '[ -z "$PS1" ] && return' does an early return)
    sudo "echo \"#{line_to_add}\" | cat - /etc/bash.bashrc > /tmp/bash.bashrc.new && mv /tmp/bash.bashrc.new /etc/bash.bashrc" if File.exist?("/etc/bash.bashrc")
    
    # Add root to the rvm group. This has to be done for every user that wants to participate.
    sudo "usermod -aG rvm root"

    # To use rvm without closing and restarting the shell, run the command in a bash -lc subshell
    # and suck relevant environment variables up into the current environment. e.g:
    ruby_vars = ['PATH','GEM_HOME','GEM_PATH','BUNDLE_PATH','MY_RUBY_HOME','IRBRC','RUBYOPT','gemset','MANPATH']
    sudo 'bash -lc "rvm --default system"'
    suck_env(`sudo bash -lc "rvm use system; echo; env"`, ruby_vars)
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
