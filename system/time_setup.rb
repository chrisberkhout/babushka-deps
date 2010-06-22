dep 'cb time setup' do
  requires \
    'cb timezone is utc',
    'cb ntp'
end


dep 'cb timezone is utc' do
  met? { `date`.include?(' UTC ') }
  meet { sudo "ln -sf /usr/share/zoneinfo/UTC /etc/localtime" }
end

dep 'cb ntp' do
  met? { `dpkg -s ntp 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install ntp" }
end
