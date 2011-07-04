dep 'ubuntu lucid 10.04' do
  met? { grep 'Ubuntu 10.04', '/etc/lsb-release' }
end

dep 'ubuntu lucid 10.04 or later' do
  met? { `cat /etc/lsb-releaseNONO`[/DISTRIB\_RELEASE\=(\d+\.\d+)/m, 1].to_f >= 10.04 }
end
