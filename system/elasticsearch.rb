dep "elasticsearch" do
  # http://www.elasticsearch.org/guide/reference/setup/installation.html
  requires \
    "java",
    "elasticsearch downloaded and extracted",
    "elasticsearch service wrapper downloaded",
    "elasticsearch service wrapper installed",
    "elasticsearch configured",
    "elasticsearch running"
end

dep "elasticsearch downloaded and extracted" do
  met? { File.exist?("/usr/local/elasticsearch/bin/elasticsearch") }
  meet {
    file_url  = "https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.16.2.tar.gz"
    file_tgz  = file_url.split("/")[-1]
    file_bare = file_tgz[0..(-1-".tar.gz".length)]
    Dir.chdir "/usr/local"
    sudo "rm -f #{file_tgz}"
    sudo "wget #{file_url}"
    sudo "tar -xzf #{file_tgz}"
    sudo "rm -f #{file_tgz}"
    sudo "rm -Rf elasticsearch"
    sudo "mv #{file_bare} elasticsearch"
  }
end

dep "elasticsearch service wrapper downloaded" do
  requires \
    "elasticsearch downloaded and extracted",
    "curl"
  met? { File.exist?("/usr/local/elasticsearch/bin/service/elasticsearch") }
  meet {
    Dir.chdir "/usr/local/elasticsearch/bin"
    shell "sudo curl -L https://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/3e0b23d | \
           sudo tar xzv --strip-components=1 --exclude README --exclude .gitignore"
  }
end

dep "elasticsearch service wrapper installed" do
  requires "elasticsearch service wrapper downloaded"
  met? { File.exist?("/etc/init.d/elasticsearch") }
  meet { sudo "/usr/local/elasticsearch/bin/service/elasticsearch install" }
end

dep "elasticsearch configured" do
  requires "elasticsearch service wrapper installed"
  define_var :elasticsearch_min_max_mem,
    :message => "What should the ElasticSearch memory limit be set to (in MB)?",
    :default => "256"
  met? {
    !changed_from_erb?('/usr/local/elasticsearch/bin/service/elasticsearch.conf', 'elasticsearch/bin_service_elasticsearch.conf.erb')
  }
  meet {
    my_render_erb "elasticsearch/bin_service_elasticsearch.conf.erb", :to => '/usr/local/elasticsearch/bin/service/elasticsearch.conf', :sudo => true
    sudo "/etc/init.d/elasticsearch restart"
  }
end

dep "elasticsearch running" do
  requires "elasticsearch service wrapper installed"
  met? { `/etc/init.d/elasticsearch status`[/^ElasticSearch is running/] }
  meet { sudo "/etc/init.d/elasticsearch start" }
end
