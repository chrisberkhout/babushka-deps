dep 'nginx' do
  requires \
    'nginx built and installed',
    'nginx init script',
    'nginx sites directories and sys config',
    'nginx running'
end


dep 'nginx built and installed' do
  requires 'nginx 0.8.53'
end

dep 'nginx 0.8.53' do
  # http://wiki.nginx.org/NginxInstall
  # http://wiki.nginx.org/NginxInstallOptions
  # http://www.cyberciti.biz/faq/debian-ubuntu-linux-install-libpcre3-dev/
  # http://freelancing-gods.com/posts/script_nginx
  requires \
    'build-essential',
    'sys libs for nginx',
    'passenger for nginx'
  met? {
    `nginx -V 2>&1`.include?('nginx version: nginx/0.8.53') &&
    `nginx -V 2>&1`.include?('--with-pcre') &&
    `nginx -V 2>&1`.include?('--with-http_ssl_module') &&
    `nginx -V 2>&1`[/--add-module=.*passenger-.*/]
  }
  meet {
    Dir.chdir '/usr/local/src'
    sudo 'wget http://nginx.org/download/nginx-0.8.53.tar.gz'
    sudo 'tar -xzf nginx-0.8.53.tar.gz'
    sudo 'rm nginx-0.8.53.tar.gz'
    Dir.chdir 'nginx-0.8.53'
    config_cmd = <<-END_OF_STRING
      ./configure \
          --with-pcre \
          --with-http_ssl_module 
          --add-module=#{`bash -lc "passenger-config --root"`.chomp}/ext/nginx
    END_OF_STRING
    shell config_cmd
    shell 'make'
    sudo  'make install'
    sudo  'ln -sf /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx'
  }
end

dep 'passenger for nginx' do
  # http://www.modrails.com/documentation/Users%20guide%20Nginx.html
  # passenger needs extra love to use an RVM ruby: http://rvm.beginrescueend.com/integration/passenger/
  # passenger v3 will support multiple rubies, but currently it only supports one: http://bit.ly/8ZMLzg
  requires \
    'build-essential',
    'rvm system ree default'
  met? { File.exist?(`bash -lc "passenger-config --root"`.chomp + '/ext/nginx/HelperServer') }
  meet {
    shell 'bash -lc "sg rvm -c \"rvm ree-1.8.7-2010.02@defualt gem install passenger --version 3.0.0\""'
    Dir.chdir( `bash -lc "passenger-config --root"`.chomp + '/ext/nginx' )
    sudo 'bash -lc "rake nginx"'    # doing this now means nginx ./configure can be done without sudo
  }
end

dep 'sys libs for nginx' do
  requires \
    'libpcre3-dev', # required for URL rewriting
    'libssl-dev',   # required for HTTPS            # defined elsewhere
    'zlib1g-dev'                                    # defined elsewhere
end

dep 'libpcre3-dev' do
  met? { `dpkg -s libpcre3-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libpcre3-dev" }
end


dep 'nginx init script' do
  # http://articles.slicehost.com/2009/3/4/ubuntu-intrepid-adding-an-nginx-init-script
  requires \
    'lsb-base',
    'nginx built and installed'
  met? {
    File.exist?('/etc/init.d/nginx') &&
    `update-rc.d -n nginx defaults 2>&1`.include?('System start/stop links for /etc/init.d/nginx already exist.')
  }
  meet {
    render_erb "nginx/etc_init.d_nginx.erb", :to => '/etc/init.d/nginx', :sudo => true
    sudo "chmod +x /etc/init.d/nginx"
    sudo "/usr/sbin/update-rc.d -f nginx defaults"
  }
end

dep 'lsb-base' do
  met? { `dpkg -s lsb-base 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install lsb-base" }
end


dep 'nginx sites directories and sys config' do
  # http://articles.slicehost.com/2009/3/4/ubuntu-intrepid-nginx-from-source-layout
  requires \
    'nginx built and installed'
  met? {
    File.exist?('/usr/local/nginx/sites-available') &&
    File.exist?('/usr/local/nginx/sites-enabled') &&
    !changed_from_erb?('/usr/local/nginx/conf/nginx.conf', 'nginx/nginx.conf.erb')
  }
  meet {
    sudo "mkdir /usr/local/nginx/sites-available"
    sudo "mkdir /usr/local/nginx/sites-enabled"
    render_erb "nginx/nginx.conf.erb", :to => '/usr/local/nginx/conf/nginx.conf', :sudo => true
    sudo "/etc/init.d/nginx restart" if File.exist?('/usr/local/nginx/logs/nginx.pid')
  }
end


dep 'nginx running' do
  requires \
    'nginx built and installed',
    'nginx init script'
  met? { File.exist?('/usr/local/nginx/logs/nginx.pid') }
  meet { sudo "/etc/init.d/nginx start" }
end
