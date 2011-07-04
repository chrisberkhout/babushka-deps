dep 'rvm system ruby19' do
  # http://rvm.beginrescueend.com/
  # http://www.rubyenterpriseedition.com/
  requires 'rvm system'
  met? { `bash -lc "rvm list"`[/\bruby\-1\.9\.2\-p180\b/] }
  meet { shell 'bash -lc "sg rvm -c \"rvm install ruby-1.9.2-p180\""' }
end

dep 'rvm system ruby19 default' do
  requires 'rvm system ruby19'
  met? { `ls -l /usr/local/rvm/rubies/default 2>&1`[/.*?\-\> \/usr\/local\/rvm\/rubies\/ruby\-1\.9\.2\-p180/] }
  meet { shell 'bash -lc "sg rvm -c \"rvm --default use ruby-1.9.2-p180\""' }
end
