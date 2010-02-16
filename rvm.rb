dep 'rvm option' do
  requires 'rvm'
  setup {
    define_var :install_rvm,
      :message => "System ruby is \""+`ruby -v 2>&1`.chomp+"\" do you want to install your own in an RVM?",
      :choices => ['yes', 'no'],
      :default => 'no'
    ask_for_var :install_rvm.to_s
    definer.payload[:requires].delete 'rvm' if var(:install_rvm)=='no'
  }
end

dep 'rvm' do
  requires \
    'sys libs for ruby',        # defined elsewhere
    # 'git', # THIS MIGHT NEED A DIFFERENT NAME
    'curl',                     # defined elsewhere
    # 'sys libs for rvm rubies',
    'build-essential'

  met? {
    nil | `sudo su #{var :username} -l -c 'rvm --version'`[/rvm \d+\.\d+\.\d+ /]
    # problem with it not running without "-l" is probably because .bashrc is fucked (has a return)
    #   - redo .bashrc by hand and test command without -l by hand
    # what about just with sudo?
    # what about in later deps?
    #   - test met? with hand made .bashrc
    #   - adjust babushka to fix .bashrc
    # note '-' maybe not working as '-l'

  }

  meet {
    as = { :as => var(:username) }
    old_home = ENV['HOME']; home = ENV['HOME'] = "/home/#{var :username}" # this changes what '~' points to

    sudo "mkdir -p #{home}/.rvm/src/", as
    Dir.chdir "#{home}/.rvm/src"
    sudo "rm -rf ./rvm/", as
    sudo "git clone git://github.com/wayneeseguin/rvm.git", as
    Dir.chdir "rvm"
    sudo "./install", as

    line_to_add = "\nif [[ -s /home/#{var :username}/.rvm/scripts/rvm ]] ; then source /home/#{var :username}/.rvm/scripts/rvm ; fi\n"
    sudo("echo \"#{line_to_add}\" >> ~/.bashrc", as)
    sudo("echo \"#{line_to_add}\" >> ~/.profile", as) if File.exist?(File.expand_path("~/.profile"))
    sudo("echo \"#{line_to_add}\" >> ~/.bash_profile", as) if File.exist?(File.expand_path("~/.bash_profile"))
    
    ENV['HOME'] = old_home
  }


end


# mkdir -p ~/.rvm/src/ && cd ~/.rvm/src && rm -rf ./rvm/ && git clone git://github.com/wayneeseguin/rvm.git && cd rvm && ./install
# 
# - install with command line from http://rvm.beginrescueend.com/install/
#   do `sudo apt-get -y install zlib1g-dev` (AND anything else that other rubies may need)
#   add to .bash_profile: "if [[ -s /home/chrisberkhout/.rvm/scripts/rvm ]] ; then source /home/chrisberkhout/.rvm/scripts/rvm ; fi"

 # *  patch is required (for ree, some ruby head's).
 # *  For JRuby (if you wish to use it) you will need:
 #    $ aptitude install curl sun-java6-bin sun-java6-jre sun-java6-jdk
 # *  For MRI & ree (if you wish to use it) you will need:
 #    $ aptitude install curl bison build-essential zlib1g-dev libssl-dev libreadline5-dev libxml2-dev git-core
 # *  For IronRuby (if you wish to use it) you will need:
 #    $ aptitude install curl mono-2.0-devel
