dep 'rubygems' do
  requires \
    'ruby',
    'rubygems latest'
end

dep 'rubygems latest' do
  requires 'rubygems-1.3.5'
  # uncomment the met? and meet blocks to have babushka update the installed rubygems to the latest
  # leave the met? and meet blocks commented out if you don't need >1.3.5 as the check takes some time
  # met? { `sudo gem update --system 2>&1`.include?('Nothing to update') }
  # meet { sudo "gem update --system" }
end

dep 'rubygems-1.3.5' do
  # http://wiki.rubyonrails.org/getting-started/installation/linux
  # http://rubyforge.org/projects/rubygems/
  # http://rubyforge.org/forum/forum.php?forum_id=33759
  requires 'build-essential'
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
