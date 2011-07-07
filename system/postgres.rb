require 'fileutils'
 
dep 'postgres' do
  # http://www.postgresql.org/docs/9.0/static/installation.html
  #
  # NOTE: 'postgres' is a default superuser role that local users 
  #       can use as DB username without additional setup.
  #
  requires \
    'postgres built and installed',
    'postgres user exists with bash shell',
    'postgres data dir set up',
    'postgres init files set up',
    'postgres environment variables set up',
    'postgres server started'
end


dep 'postgres built and installed' do
  requires \
    'postgres basic sys libs',
    'postgres procedural langs',
    'postgres auth and encryption libs'
  met? {
    File.exists?('/usr/local/pgsql/bin/postgres') &&
    `/usr/local/pgsql/bin/postgres --version`['postgres (PostgreSQL) 9.0.3'] &&
    File.exists?('/usr/local/pgsql/bin/pg_config') &&
    `/usr/local/pgsql/bin/pg_config --configure`['--with-tcl'] &&
    `/usr/local/pgsql/bin/pg_config --configure`['--with-perl'] &&
    `/usr/local/pgsql/bin/pg_config --configure`['--with-python'] &&
    `/usr/local/pgsql/bin/pg_config --configure`['--with-openssl']
  }
  meet {
    Dir.chdir '/usr/local/src'
    sudo 'rm postgresql-9.0.3.tar.gz'
    sudo 'wget http://wwwmaster.postgresql.org/redir/333/h/source/v9.0.3/postgresql-9.0.3.tar.gz'
    sudo 'tar -xzf postgresql-9.0.3.tar.gz'
    sudo 'rm postgresql-9.0.3.tar.gz'
    Dir.chdir 'postgresql-9.0.3'
    config_cmd = <<-END_OF_CMD
      ./configure \
          --with-tcl \
          --with-perl \
          --with-python PYTHON='/usr/bin/python3.1' \
          --with-openssl
    END_OF_CMD
    shell config_cmd
    shell 'make'
    sudo  'make install'
  }
end

dep 'postgres basic sys libs' do
  requires \
    'zlib1g-dev',
    'libreadline5-dev',
    'lsb-base'
end

dep 'postgres procedural langs' do
  requires \
    'tcl8.4-dev',  # For PL/Tcl
    'libperl-dev', # For PL/Perl
    'python3-dev'  # For PL/Python
end

dep 'tcl8.4-dev' do
  met? { `dpkg -s tcl8.4-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install tcl8.4-dev" }
end
dep 'libperl-dev' do
  met? { `dpkg -s libperl-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install libperl-dev" }
end
dep 'python3-dev' do
  met? { `dpkg -s python3-dev 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install python3-dev" }
end

dep 'postgres auth and encryption libs' do
  requires \
    'openssl'
    # Not including: Kerberos ('libkrb5-dev'?), LDAP ('openldap2-dev') or PAM ('libpam0g-dev').
end

    
dep 'postgres user exists with bash shell' do
  met? { grep(/^postgres:.*?:\/bin\/bash$/, '/etc/passwd') }
  meet { 
    # There are problems if the postgres user doesn't have the bash shell
    sudo 'adduser postgres --system --group --no-create-home --disabled-password --disabled-login --shell "/bin/bash"'
  }
end


dep 'postgres data dir set up' do
  requires \
    'postgres built and installed',
    'postgres user exists with bash shell'
  met? {
    File.directory?('/usr/local/pgsql/data') &&
    !dir_empty?('/usr/local/pgsql/data', :sudo => true) &&
    owner_and_group?('/usr/local/pgsql/data', 'postgres:postgres')
  }
  meet {
    sudo 'mkdir -p /usr/local/pgsql/data'
    sudo 'chown -R postgres:postgres /usr/local/pgsql/data'
    init_cmd = <<-END_OF_CMD
      /usr/local/pgsql/bin/initdb \
          --auth="trust" \
          --pgdata=/usr/local/pgsql/data \
          --locale=en_US.UTF-8 \
          --encoding=UTF8 \
          --text-search-config="english"
    END_OF_CMD
    sudo init_cmd, :as => 'postgres'
  }
end


dep 'postgres environment variables set up' do
  requires \
    'postgres built and installed'
  met? { 
    !changed_from_erb?('/etc/profile.d/postgres.sh', 'postgres/etc_profile.d_postgres.sh.erb') &&
    File.executable?('/etc/profile.d/postgres.sh') &&
    grep(%r{source /etc/profile\.d/postgres\.sh}, "/etc/bash.bashrc")
  }
  meet {
    my_render_erb "postgres/etc_profile.d_postgres.sh.erb", :to => '/etc/profile.d/postgres.sh', :sudo => true
    sudo 'chmod +x /etc/profile.d/postgres.sh'
    # For non-login shells
    unless grep(%r{source /etc/profile\.d/postgres\.sh}, "/etc/bash.bashrc")
      line_to_add = "\n# Postgres env variable setup \nif [[ -s /etc/profile.d/postgres.sh ]] ; then source /etc/profile.d/postgres.sh ; fi\n"
      sudo "echo \"#{line_to_add}\" | cat - /etc/bash.bashrc > /tmp/bash.bashrc.new && mv /tmp/bash.bashrc.new /etc/bash.bashrc"
    end
  }
end


dep 'postgres init files set up' do
  requires \
    'postgres built and installed',
    'postgres user exists with bash shell',
    'postgres data dir set up'
  met? {
    !changed_from_erb?('/etc/init.d/postgres', 'postgres/etc_init.d_postgres.erb') &&
    File.executable?('/etc/init.d/postgres') &&
    `sudo update-rc.d postgres defaults`['System start/stop links for /etc/init.d/postgres already exist.']
  }
  meet {
    my_render_erb "postgres/etc_init.d_postgres.erb", :to => '/etc/init.d/postgres', :sudo => true
    sudo  'chmod +x /etc/init.d/postgres'
    sudo  'update-rc.d postgres defaults'
  }
end


dep 'postgres server started' do
  requires 'postgres init files set up'
  met? { `/etc/init.d/postgres status`['pg_ctl: server is running'] }
  meet { shell '/etc/init.d/postgres start' }
end

