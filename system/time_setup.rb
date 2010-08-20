dep 'time setup' do
  requires \
    'timezone is utc',
    'ntp'
end


dep 'timezone is utc' do
  met? { `date`.include?(' UTC ') }
  meet { sudo "ln -sf /usr/share/zoneinfo/UTC /etc/localtime" }
end

dep 'ntp' do
  met? { `dpkg -s ntp 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install ntp" }
end
