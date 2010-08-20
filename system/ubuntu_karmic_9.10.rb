dep 'ubuntu karmic 9.10' do
  met? { grep 'Ubuntu 9.10', '/etc/lsb-release' }
end

dep 'ubuntu karmic 9.10 or later' do
  met? { `cat /etc/lsb-release`[/DISTRIB\_RELEASE\=(\d+\.\d+)/m, 1].to_f >= 9.10 }
end
