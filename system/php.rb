dep 'php' do
  # http://library.linode.com/web-servers/nginx/php-fastcgi/ubuntu-10.04-lucid
  requires \
    'nginx',
    'php5-cli',
    'php-fastcgi'
end

dep 'php5-cli' do
  met? { `dpkg -s php5-cli 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install php5-cli" }
end


dep 'php-fastcgi' do
  requires \
    'php-fastcgi wrapper',
    'php-fastcgi init.d'    
end


dep 'php-fastcgi wrapper' do
  requires \
    'php5-cgi',
    'spawn-fcgi'
  met? { !changed_from_erb?("/usr/bin/php-fastcgi", "php/usr_bin_php-fastcgi.erb") && File.executable?("/usr/bin/php-fastcgi") }
  meet { render_erb "php/usr_bin_php-fastcgi.erb", :to => "/usr/bin/php-fastcgi", :perms => '755', :sudo => true }
end

dep 'php5-cgi' do
  met? { `dpkg -s php5-cgi 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install php5-cgi" }
end
dep 'spawn-fcgi' do
  met? { `dpkg -s spawn-fcgi 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install spawn-fcgi" }
end


dep 'php-fastcgi init.d' do
  requires 'php-fastcgi wrapper'
  met? { 
    !changed_from_erb?("/etc/init.d/php-fastcgi", "php/etc_init.d_php-fastcgi.erb") &&
    `ps -aux`[/\/usr\/bin\/php5\-cgi/]
  }
  meet { 
    render_erb "php/etc_init.d_php-fastcgi.erb", :to => "/etc/init.d/php-fastcgi", :perms => '755', :sudo => true 
    shell "update-rc.d php-fastcgi defaults", :sudo => true
    shell "/etc/init.d/php-fastcgi start", :sudo => true
  }
end
