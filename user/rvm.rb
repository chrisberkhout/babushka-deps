dep 'cb rvm' do
  # http://rvm.beginrescueend.com/rvm/install/
  requires \
    'cb curl',                     # defined elsewhere
    'cb build-essential',          # defined elsewhere
    #'cb sys libs for jruby',
    #'cb sys libs for ironruby',
    'cb sys libs for mri and ree',
    'cb sys libs for ruby'         # defined elsewhere

  met? { 
    shell('rvm --version')[/rvm \d+\.\d+\.\d+ /] 
  }
  meet {
    shell "mkdir -p ~/.rvm/src/"
    Dir.chdir(File.expand_path("~/.rvm/src"))
    shell "rm -rf ./rvm/"
    shell "git clone git://github.com/wayneeseguin/rvm.git"
    Dir.chdir "rvm"
    shell "./install"

    line_to_add = "\n# RVM (Ruby Version Manager)\nif [[ -s /home/#{var :username}/.rvm/scripts/rvm ]] ; then source /home/#{var :username}/.rvm/scripts/rvm ; fi\n"
    shell "echo \"#{line_to_add}\" >> ~/.bashrc" if File.exist?(File.expand_path("~/.bashrc"))
    shell "echo \"#{line_to_add}\" >> ~/.profile" if File.exist?(File.expand_path("~/.profile"))
    shell "echo \"#{line_to_add}\" >> ~/.bash_profile" if File.exist?(File.expand_path("~/.bash_profile"))
    
    # set a default ruby!
  }
end


dep 'cb sys libs for mri and ree' do
  requires \
    'cb libssl-dev',        # defined elsewhere
    'cb libreadline5-dev',  # defined elsewhere
    'cb zlib1g-dev',        # defined elsewhere
    'cb build-essential',   # defined elsewhere
    'cb bison',             # defined elsewhere
    'cb libxml2-dev'
end

dep 'cb libxml2-dev' do
  met? { `dpkg -s libxml2-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libxml2-dev" }
end


dep 'cb sys libs for jruby' do
  requires 'cb java6'
end


dep 'cb sys libs for ironruby' do
  requires 'cb mono-2.0-devel'
end

dep 'cb mono-2.0-devel' do
  met? { `dpkg -s mono-2.0-devel 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install mono-2.0-devel" }
end
