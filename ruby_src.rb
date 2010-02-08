dep 'ruby src' do
  requires 'ruby-1.8.7-p248'
end


dep 'ruby-1.8.7-p248' do
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
    shell 'hash -r' # this clears the cached executable locations without having to start a new shell
  }
end
