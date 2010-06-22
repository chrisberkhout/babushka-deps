dep 'cb rubygems' do
  requires \
    'cb ruby',
    'cb rubygems installed and up to date',
    'cb rubygems sources'
end


dep 'cb rubygems installed and up to date' do
  requires 'cb rubygems-1.3.5'
  # uncomment the following to update the installed rubygems to the latest, otherwise save time and just use 1.3.5
  # met? { `sudo gem update --system 2>&1`.include?('Nothing to update') }
  # meet { sudo "gem update --system" }
end


dep 'cb rubygems-1.3.5' do
  # http://wiki.rubyonrails.org/getting-started/installation/linux
  # http://rubyforge.org/projects/rubygems/
  # http://rubyforge.org/forum/forum.php?forum_id=33759
  requires 'cb build-essential'
  met? { `/usr/local/bin/gem --version 2>&1`.include?("1.3.5\n") }
  meet { 
    Dir.chdir '/usr/local/src'
    shell 'rm -Rf rubygems-1.3.5'
    shell 'wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz'
    shell 'tar -xzf rubygems-1.3.5.tgz'
    shell 'rm rubygems-1.3.5.tgz'
    Dir.chdir 'rubygems-1.3.5'
    sudo  'ruby setup.rb'
  }
end


dep 'cb rubygems sources' do
  requires \
    'cb rubygems source rubyforge',
    'cb rubygems source gemcutter',
    'cb rubygems source github'
end


dep 'cb rubygems source rubyforge' do
  # http://update.gemcutter.org/2009/10/26/transition.html
  requires 'cb rubygems installed and up to date'
  met? { `gem sources`.include?('http://gems.rubyforge.org/') }
  meet { sudo "gem sources --add http://gems.rubyforge.org/" }
end

dep 'cb rubygems source gemcutter' do
  # http://update.gemcutter.org/2009/10/26/transition.html
  requires 'cb rubygems installed and up to date'
  met? { `gem sources`.include?('http://gemcutter.org') }
  meet { sudo "gem sources --add http://gemcutter.org" }
end

dep 'cb rubygems source github' do
  # http://github.com/blog/515-gem-building-is-defunct
  requires 'cb rubygems installed and up to date'
  met? { `gem sources`.include?('http://gems.github.com') }
  meet { sudo "gem sources --add http://gems.github.com" }
end

