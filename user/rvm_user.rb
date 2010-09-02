dep 'rvm user' do
  # http://rvm.beginrescueend.com/rvm/install/
  #
  # This installs rvm for the current user only. It can coexist a system-wide install.
  # System-wide install is preferable according to: http://rvm.beginrescueend.com/deployment/best-practices/
  #
  requires \
    'curl',                     # defined elsewhere
    'build-essential',          # defined elsewhere
    #'sys libs for jruby',       # not needed unless using jruby      # defined elsewhere
    #'sys libs for ironruby',    # not needed unless using ironruby   # defined elsewhere
    'sys libs for mri and ree', # defined elsewhere
    'sys libs for ruby'         # defined elsewhere

  met? { 
    # This works if user rvm has been installed, even if the shell hasn't been closed and reopened.
    File.exist?(File.expand_path("~/.rvm/scripts/rvm")) && 
    `bash -lc "rvm --version" 2>&1`[/rvm \d+\.\d+\.\d+ /] &&
    `bash -lc "type rvm | head -n1"`[/^rvm is a function/] &&
    `bash -lc "env | grep ^rvm_path="`[/^rvm_path=#{ENV['HOME']}\/\.rvm$/]
  }
  meet {
    # This file sets variables for user-specific rvm (overriding /etc/rvmrc).
    render_erb "rvm_user/rvmrc.erb", :to => '~/.rvmrc'    
    
    # Load those variables (just in case the rvm install script starts using different defaults).
    ENV.keys.select{ |k| !k[/^rvm_/].nil? }.each{ |k| ENV.delete(k) }
    suck_env(`bash -lc "source ~/.rvmrc; echo; env"`, /^rvm_/)
    
    shell "mkdir -p ~/.rvm/src/"
    Dir.chdir(File.expand_path("~/.rvm/src"))
    shell "rm -rf ./rvm/"
    shell "git clone git://github.com/wayneeseguin/rvm.git"
    Dir.chdir "rvm"
    shell "./install"

    line_to_add = "\n# RVM (Ruby Version Manager)\nif [[ -s #{ENV['HOME']}/.rvm/scripts/rvm ]] ; then source #{ENV['HOME']}/.rvm/scripts/rvm ; fi\n"
    # For login shells:
    shell "echo \"#{line_to_add}\" >> ~/.bash_profile" if File.exist?(File.expand_path("~/.bash_profile"))
    shell "echo \"#{line_to_add}\" >> ~/.bash_login" if File.exist?(File.expand_path("~/.bash_login"))
    shell "echo \"#{line_to_add}\" >> ~/.profile" if File.exist?(File.expand_path("~/.profile"))
    # For non-login shells: (prepend so that it runs before '[ -z "$PS1" ] && return' does an early return)
    shell "echo \"#{line_to_add}\" | cat - ~/.bashrc > ~/.bashrc.new && mv ~/.bashrc.new ~/.bashrc" if File.exist?(File.expand_path("~/.bashrc"))

    # Set a user (not system!) default ruby
    shell 'bash -lc "rvm --default system"'
    
    # To use rvm without closing and restarting the shell, run the command in a bash -lc subshell
    # and suck relevant environment variables up into the current environment. e.g:
    ruby_vars = ['PATH','GEM_HOME','GEM_PATH','BUNDLE_PATH','MY_RUBY_HOME','IRBRC','RUBYOPT','gemset','MANPATH']
    suck_env(`bash -lc "rvm use system; echo; env"`, ruby_vars)

  }
end
