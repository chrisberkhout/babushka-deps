dep 'ruby' do
  requires 'ruby src'
end

dep 'ruby src' do
  requires 'ruby-1.8.7-p248'
end


dep 'ruby-1.8.7-p248' do
  # http://wiki.rubyonrails.org/getting-started/installation/linux
  # http://www.ruby-lang.org/en/news/2009/12/25/ruby-1-8-7-p248-released/
  requires \
    'build-essential',
    'sys libs for ruby'
  met? { 
    `ruby -v 2>&1`.include?("ruby 1.8.7") &&
    `ruby -v 2>&1`.include?("patchlevel 248)") &&
    `ruby -ropenssl -rzlib -rreadline -e "puts :NoWorriesMate"`.include?('NoWorriesMate')
  }
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


dep 'sys libs for ruby' do
  requires \
    'libssl-dev',
    'libreadline5-dev',
    'zlib1g-dev',
    'libxml2-dev', # for MRI & REE
    'bison'        # for MRI & REE
end

dep 'libssl-dev' do
  met? { `dpkg -s libssl-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libssl-dev" }
end

dep 'libreadline5-dev' do
  met? { `dpkg -s libreadline5-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libreadline5-dev" }
end

dep 'zlib1g-dev' do
  met? { `dpkg -s zlib1g-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install zlib1g-dev" }
end
