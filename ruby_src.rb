dep 'ruby src' do
  requires 'ruby-1.8.7-p248'
end


dep 'ruby-1.8.7-p248' do
  requires 'build-essential'
  # some claim this also requires an `apt-get install libssl-dev libreadline5-dev zlib1g-dev`
  #   http://wiki.rubyonrails.org/getting-started/installation/linux
  # could also use checkinstall so that it can be more easily uninstalled (see https://help.ubuntu.com/community/CheckInstall)
  met? { `ruby -v 2>&1`.include?("ruby 1.8.7 (2009-12-24 patchlevel 248)") }
  meet { 
    Dir.chdir '/usr/local/src'
    shell 'rm -Rf ruby-1.8.7-p248'
    shell 'wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p248.tar.gz'
    shell 'tar -xzf ruby-1.8.7-p248.tar.gz'
    shell 'rm ruby-1.8.7-p248.tar.gz'
    Dir.chdir 'ruby-1.8.7-p248'
    shell './configure'
    shell 'make'
    shell 'make test'
    sudo  'make install'
    # `hash -r` # this tells bash to clear cached executable locations without having to start a new shell
  }
end
