dep 'rvm system ree default' do
  # http://rvm.beginrescueend.com/
  # http://www.rubyenterpriseedition.com/
  requires 'rvm system ree'
  met? { `ls -l /usr/local/rvm/bin/ruby 2>&1`[/.*?\-\> \/usr\/local\/rvm\/wrappers\/ree\-1\.8\.7\-2010\.02\/ruby/] }
  meet { shell 'bash -lc "sg rvm -c \"rvm --default use ree-1.8.7-2010.02\""' }
end

dep 'rvm system ree' do
  requires 'rvm system'
  met? { `bash -lc "rvm list"`[/\bree\-1\.8\.7\-2010\.02\b/] }
  meet { shell 'bash -lc "sg rvm -c \"rvm install ree-1.8.7-2010.02\""' }
end
