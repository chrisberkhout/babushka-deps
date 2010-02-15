
dep 'rvm user' do
  requires \
    'sys libs for ruby',        # defined elsewhere
    'curl',                     # defined elsewhere
    'sys libs for rvm rubys',
    'build-essential'

  met? {
  }

  meet {
  }



end

# mkdir -p ~/.rvm/src/ && cd ~/.rvm/src && rm -rf ./rvm/ && git clone git://github.com/wayneeseguin/rvm.git && cd rvm && ./install
# 
# - install with command line from http://rvm.beginrescueend.com/install/
#   do `sudo apt-get -y install zlib1g-dev` (AND anything else that other rubies may need)
#   add to .bash_profile: "if [[ -s /home/chrisberkhout/.rvm/scripts/rvm ]] ; then source /home/chrisberkhout/.rvm/scripts/rvm ; fi"
