dep 'postgres' do
  # http://www.postgresql.org/docs/9.0/static/installation.html
  requires \
    'postgres basic sys libs',
    'postgres procedural langs',
    'postgres auth and encryption libs'
  met? {
    false
  }
  meet {
    Dir.chdir '/usr/local/src'
    sudo 'wget http://wwwmaster.postgresql.org/redir/198/h/source/v9.0.1/postgresql-9.0.1.tar.gz'
    sudo 'tar -xzf postgresql-9.0.1.tar.gz'
    sudo 'rm postgresql-9.0.1.tar.gz'
    Dir.chdir 'postgresql-9.0.1'
    config_cmd = <<-END_OF_CMD
      ./configure \
          --with-tcl \
          --with-perl \
          --with-python \
          --with-openssl
    END_OF_CMD
    shell config_cmd
    shell 'make'
    sudo  'make install'
    sudo  'adduser postgres --system --no-create-home --group --disabled-password --disabled-login'
    sudo  'mkdir /usr/local/pgsql/data'
    sudo  'chown postgres /usr/local/pgsql/data'
    sudo  '/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data', :as => 'postgres'
  }
end


dep 'postgres basic sys libs' do
  requires \
    'zlib1g-dev',
    'libreadline5-dev'
end


dep 'postgres procedural langs' do
  requires \
    'tcl8.4',      # For PL/Tcl
    'libperl-dev', # For PL/Perl
    'python3-dev'  # For PL/Python
end

dep 'tcl8.4' do
  met? { `dpkg -s tcl8.4 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install tcl8.4" }
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
