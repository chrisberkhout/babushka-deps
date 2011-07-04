dep 'ubuntu lucid 10.04' do
  met? { grep 'Ubuntu 10.04', '/etc/lsb-releaseNONO' }
end

dep 'ubuntu lucid 10.04 or later' do
  met? { `cat /etc/lsb-release`[/DISTRIB\_RELEASE\=(\d+\.\d+)/m, 1].to_f >= 10.04 }
end
