dep 'sphinx' do
  # NOTE: I'm leaving it up to any app wanting sphinx to do the start/stop stuff.  
  # http://www.hackido.com/2009/01/install-sphinx-search-on-ubuntu.html
  # http://sphinxsearch.com/wiki/doku.php?id=sphinx_sphinxse_on_ubuntu_karmic_9.10
  requires \
    'mysql',
    'build-essential'
  met? {
    `indexer 2>&1`.include?('Sphinx 0.9.9-release') &&
    `searchd 2>&1`.include?('Sphinx 0.9.9-release') &&
    `search  2>&1`.include?('Sphinx 0.9.9-release')
  }
  meet {
    Dir.chdir '/usr/local/src'
    sudo 'wget http://sphinxsearch.com/files/sphinx-0.9.9.tar.gz'
    sudo 'tar -xzf sphinx-0.9.9.tar.gz'
    sudo 'rm sphinx-0.9.9.tar.gz'
    Dir.chdir 'sphinx-0.9.9'
    config_cmd = <<-END_OF_CMD
      ./configure \
          --with-mysql-includes=/usr/include/mysql \
          --with-mysql-libs=/usr/lib/mysql
    END_OF_CMD
    sudo config_cmd
    sudo 'make'
    sudo 'make install'
  }
end
