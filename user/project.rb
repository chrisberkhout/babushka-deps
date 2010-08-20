dep 'project' do
  requires \
    'assets directory exists',
    'proj from git repo'
end


dep 'assets directory exists' do
  met? { File.directory? ENV['HOME']+'/assets' }
  meet { Dir.mkdir ENV['HOME']+'/assets' }  
end

dep 'proj from git repo' do
  requires 'github in known hosts'
  met? { grep var(:git_repo), ENV['HOME']+'/current/.git/config' }
  meet { shell "git clone #{var(:git_repo)} #{ENV['HOME']}/current" }  
end
