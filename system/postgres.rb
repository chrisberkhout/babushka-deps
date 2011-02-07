dep 'postgres' do
  # http://www.postgresql.org/docs/9.0/static/installation.html
  requires \
    'postgres basic sys libs',
    'postgres procedural langs',
    'postgres auth and encryption libs'
  met? {
    false
    
    # postgres installed, and with right stuff compiled in
        # chris@ubuntu:~$ /usr/local/pgsql/bin/postgres --version
        # postgres (PostgreSQL) 9.0.3
        # chris@ubuntu:~$ /usr/local/pgsql/bin/pg_config --configure
        # '--with-tcl' '--with-perl' '--with-python' 'PYTHON=/usr/bin/python3.1' '--with-openssl'
    
    # profile.d setup to add PG's bin dir to path
    
    # postgres user added
    
    # data directory setup, correct owner & db files initialised
        # chris@ubuntu:~$ sudo -u postgres /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
        # [sudo] password for chris: 
        # The files belonging to this database system will be owned by user "postgres".
        # This user must also own the server process.
        # 
        # The database cluster will be initialized with locale en_US.UTF-8.
        # The default database encoding has accordingly been set to UTF8.
        # The default text search configuration will be set to "english".
        # 
        # initdb: directory "/usr/local/pgsql/data" exists but is not empty
        # If you want to create a new database system, either remove or empty
        # the directory "/usr/local/pgsql/data" or run initdb
        # with an argument other than "/usr/local/pgsql/data".
    
    # init files set up
        # chris@ubuntu:~$ sudo update-rc.d postgres defaults
        #  System start/stop links for /etc/init.d/postgres already exist.
    
  }
  meet {
    Dir.chdir '/usr/local/src'
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
    
    # There are problems if the postgres user doesn't have the bash shell
    sudo  'adduser postgres --system --group --no-create-home --disabled-password --disabled-login --shell "/bin/bash"'
    sudo  'mkdir -p /usr/local/pgsql/data'
    sudo  'chown -R postgres:postgres /usr/local/pgsql/data'
    init_cmd = <<-END_OF_CMD
      /usr/local/pgsql/bin/initdb \
          --auth="trust" \
          --pgdata=/usr/local/pgsql/data \
          --locale=en_US.UTF-8 \
          --encoding=UTF8 \
          --text-search-config="english"
    END_OF_CMD
    sudo init_cmd, :as => 'postgres'
    
    my_render_erb "postgres/etc_profile.d_postgres.sh.erb", :to => '/etc/profile.d/postgres.sh', :sudo => true
    sudo  'chmod +x /etc/profile.d/postgres.sh'

    my_render_erb "postgres/etc_init.d_postgres.erb", :to => '/etc/init.d/postgres', :sudo => true
    sudo  'chmod +x /etc/init.d/postgres'
    sudo  'update-rc.d postgres defaults'
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
