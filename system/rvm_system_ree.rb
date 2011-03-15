dep 'rvm system ree' do
  # http://rvm.beginrescueend.com/
  # http://www.rubyenterpriseedition.com/
  requires 'rvm system'
  met? { `bash -lc "rvm list"`[/\bree\-1\.8\.7\-2010\.02\b/] }
  meet { shell 'bash -lc "sg rvm -c \"rvm install ree-1.8.7-2010.02\""' }
end

dep 'rvm system ree default' do
  requires 'rvm system ree'
  met? { `ls -l /usr/local/rvm/rubies/default 2>&1`[/.*?\-\> \/usr\/local\/rvm\/rubies\/ree\-1\.8\.7\-2010\.02/] }
  meet { shell 'bash -lc "sg rvm -c \"rvm --default use ree-1.8.7-2010.02\""' }
end
