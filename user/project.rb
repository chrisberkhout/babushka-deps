dep 'project' do
  requires \
    'proj directories set up',
    'proj clone from git',
    'proj bundle install if gemfile exists'
end


dep 'proj directories set up' do
  requires \
    '~ current',
    '~ shared',
    '~ shared assets',
    '~ shared log'
end

dep '~ current' do
  met? { File.directory? ENV['HOME']+'/current' }
  meet { Dir.mkdir ENV['HOME']+'/current' }  
end
dep '~ shared' do
  met? { File.directory? ENV['HOME']+'/shared' }
  meet { Dir.mkdir ENV['HOME']+'/shared' }  
end
dep '~ shared assets' do
  requires '~ shared'
  met? { File.directory? ENV['HOME']+'/shared/assets' }
  meet { Dir.mkdir ENV['HOME']+'/shared/assets' }  
end
dep '~ shared log' do
  requires '~ shared'
  met? { File.directory? ENV['HOME']+'/shared/log' }
  meet { Dir.mkdir ENV['HOME']+'/shared/log' }  
end


dep 'proj clone from git' do
  requires \
    'github in known hosts',
    'proj directories set up'
  met? { grep var(:git_repo), ENV['HOME']+'/current/.git/config' }
  meet { shell "git clone #{var(:git_repo)} #{ENV['HOME']}/current" }  
end


dep 'proj bundle install if gemfile exists' do
  requires \
    'proj clone from git',
    'bundler gem'
  met? { 
    !File.exist?("#{ENV['HOME']}/current/Gemfile") ||
    shell('bash -lc "bundle check"', :dir => "#{ENV['HOME']}/current")[/The Gemfile's dependencies are satisfied/]
  }
  meet { 
    shell('bash -lc "bundle install --deployment"', :dir => "#{ENV['HOME']}/current")
  }
end

dep 'bundler gem' do
  requires 'rvm system ree default'
  met? { `bash -lc "gem list bundler" 2>&1`[/bundler (\d+\.\d+\.\d+)/] }
  meet { shell 'bash -lc "sg rvm -c \"rvm ree-1.8.7-2010.02@default gem install bundler\""' }
end

