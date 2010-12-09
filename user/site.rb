dep 'site' do
  requires \
    'nginx',
    'account'

  setup {
    dep_confs  = ["site/clean.conf.erb", "site/www.conf.erb", "site/wildcard.conf.erb"]
    repo_confs = Dir.glob("#{ENV['HOME']}/current/config/deploy/nginx-site{,-#{`hostname`.chomp}}.conf{,.erb}").sort
    define_var :site_config,
      :message => "Which nginx config file should be used for this site?",
      :choices => repo_confs + dep_confs
      :default => repo_confs.first || dep_confs.first
    
    define_var :site_hostname,
      :message => "What is the hostname for this site (without prefixes like 'www.' or suffixes like '.com.au')?"
      
    set :site_config_destination, "/usr/local/nginx/sites-available/#{var :site_hostname}.conf"
    set :site_enabled_link, "/usr/local/nginx/sites-enabled/#{var :site_hostname}.conf"
  }

  met? {
    !changed_from_erb?(var(:site_config_destination), var(:site_config)) &&
    File.symlink?(var(:site_enabled_link))
  }

  meet {
    render_erb var(:site_config), :to => var(:site_config_destination), :sudo => true
    shell "ln -sf #{var :site_config_destination} #{var :site_enabled_link}", :sudo => true
    shell "/etc/init.d/nginx restart", :sudo => true
  }
end
