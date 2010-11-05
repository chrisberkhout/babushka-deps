dep 'rvm system ree default' do
  # http://rvm.beginrescueend.com/
  # http://www.rubyenterpriseedition.com/
  requires 'rvm system ree'
  met? {
    `ls -l /usr/local/rvm/bin/ruby 2>&1`[/.*?\-\> \/usr\/local\/rvm\/wrappers\/ree\-1\.8\.7\-2010\.02\/ruby/] &&
    `ls -l /usr/local/rvm/bin/gem 2>&1`[/.*?\-\> \/usr\/local\/rvm\/wrappers\/ree\-1\.8\.7\-2010\.02\/gem/]
  }
  meet { 
    sudo 'bash -lc "rvm --default use ree-1.8.7-2010.02"' 
    # Takes effect immediately because PATH already includes location of the new links.
  }
end

dep 'rvm system ree' do
  requires 'rvm system'
  met? { `bash -lc "rvm list"`[/\bree\-1\.8\.7\-2010\.02\b/] }
  meet { sudo 'bash -lc "rvm install ree-1.8.7-2010.02"' }
end
