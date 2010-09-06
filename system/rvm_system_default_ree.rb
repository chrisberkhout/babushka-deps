dep 'rvm system default ree' do
  # http://rvm.beginrescueend.com/
  # http://www.rubyenterpriseedition.com/
  #
  # WARNING: This will clobber any existing source install of ruby at /usr/local/bin/ruby.

  requires 'rvm system'

  met? { 
    # re-check that it's system rvm, not user rvm
    `bash -lc "type rvm | head -n1 2>&1"`[/^rvm is a function/] &&
    `bash -lc "env | grep ^rvm_path="`[/^rvm_path=\/usr\/local\/rvm$/] &&
    # check that ree is installed and default
    `bash -lc "rvm list default"`[/\bree\-1\.8\.7\-2010\.02\b/] &&
    # check that the symlinks have been set
    `ls -l /usr/local/bin/ruby`[/.*?\-\> \/usr\/local\/rvm\/wrappers\/ree\-1\.8\.7\-2010\.02\/ruby/]
    `ls -l /usr/local/bin/gem`[/.*?\-\> \/usr\/local\/rvm\/wrappers\/ree\-1\.8\.7\-2010\.02\/gem/]
  }
  meet {
    sudo 'bash -lc "rvm install ree-1.8.7-2010.02"'
    sudo 'bash -lc "rvm --default ree-1.8.7-2010.02"'
    # This takes effect immediately because the symlinks set were already in the PATH
  }
end
