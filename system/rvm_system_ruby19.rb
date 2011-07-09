dep 'rvm system ruby19' do
  # http://rvm.beginrescueend.com/
  # 
  # GROUP PERMISSIONS ARE MANUALLY ADJUSTED after installation to address the 
  # the problem of rvm group members (other than the installer of the ruby) 
  # don't have permissions under /usr/local/rvm/rubies/* that are needed to 
  # install some gems with native extensions.
  # 
  # A gist of the error (when installing linecache19): https://gist.github.com/a1e752edb8f14737dd28
  # A writeup from someone with the same issue: http://groups.google.com/group/rubyversionmanager/browse_thread/thread/45b4064f1d7f56c6/9d0ca5d05187522d
  # A similar issue on Heroku: http://stackoverflow.com/questions/6324136/error-while-pushing-app-to-herokuinstalling-linecache19-0-5-12-with-native-ext
  #
  requires 'rvm system'
  met? { `bash -lc "rvm list"`[/\bruby\-1\.9\.2\-p180\b/] }
  meet { 
    shell 'bash -lc "sg rvm -c \"rvm install ruby-1.9.2-p180\""'
    shell 'chmod -R g+w /usr/local/rvm/rubies/ruby-1.9.2-p180'
  }
end

dep 'rvm system ruby19 default' do
  requires 'rvm system ruby19'
  met? { `ls -l /usr/local/rvm/rubies/default 2>&1`[/.*?\-\> \/usr\/local\/rvm\/rubies\/ruby\-1\.9\.2\-p180/] }
  meet { shell 'bash -lc "sg rvm -c \"rvm --default use ruby-1.9.2-p180\""' }
end
