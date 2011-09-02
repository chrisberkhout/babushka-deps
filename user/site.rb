dep 'site' do
  requires 'nginx', 'account', 'site log dir'

  setup {
    define_var :site_config_selection,
      :message => "Which general purpose nginx config file should be used for this site?",
      :choices => ["clean", "www", "wildcard"],
      :default => "clean"
    set :site_config_source, "site/#{var :site_config_selection}.conf.erb"
    define_var :site_config_locations,
      :message => "Which location statements do you want in the nginx config file?",
      :choices => ["passenger", "php"],
      :default => "passenger"
    
    define_var :site_hostname,
      :message => "What is the hostname for this site (without prefixes like 'www.' or suffixes like '.com.au')?"
      
    set :site_config_destination, "/usr/local/nginx/sites-available/#{var :site_hostname}.conf"
    set :site_enabled_link, "/usr/local/nginx/sites-enabled/#{var :site_hostname}.conf"
  }

  met? {
    !changed_from_erb?(var(:site_config_destination), var(:site_config_source)) &&
    File.symlink?(var(:site_enabled_link))
  }

  meet {
    puts "Using nginx site config from: #{var :site_config_source}"
    my_render_erb var(:site_config_source), :to => var(:site_config_destination), :sudo => true
    shell "ln -sf #{var :site_config_destination} #{var :site_enabled_link}", :sudo => true
    shell "/etc/init.d/nginx restart", :sudo => true
  }
end

dep 'site log dir' do
  met? { 
    File.exist?("#{home_of(var :username)}/shared/log") &&
    owner_and_group?("#{home_of(var :username)}/shared/log", "#{var :username}:#{var :username}")
  }
  meet { 
    sudo "mkdir -p #{home_of(var :username)}/shared/log" 
    sudo "chown #{var :username}:#{var :username} \"#{home_of(var :username)}/shared/log\""
  }
end
