dep 'site' do
  # requires 'nginx', 'account'

  setup {
    repo_confs = Dir.glob("#{ENV['HOME']}/current/config/deploy/nginx-site{,-#{`hostname`.chomp}}.conf{,.erb}").sort
    if repo_confs.first
      set :site_config_source, repo_confs.first
    else
      define_var :site_config_selection,
        :message => "Which general purpose nginx config file should be used for this site?",
        :choices => ["clean", "www", "wildcard"],
        :default => "clean"
      set :site_config_source, "site/#{var :site_config_selection}.conf.erb"
    end
    
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
    puts "Using nginx site config from: #{var :site_config_source}"
    render_erb var(:site_config), :to => var(:site_config_destination), :sudo => true
    shell "ln -sf #{var :site_config_destination} #{var :site_enabled_link}", :sudo => true
    shell "/etc/init.d/nginx restart", :sudo => true
  }
end
