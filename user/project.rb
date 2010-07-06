dep 'cb project' do
  requires \
    'cb assets directory exists',
    'cb proj from git repo'
end


dep 'cb assets directory exists' do
  met? { File.directory? ENV['HOME']+'/assets' }
  meet { Dir.mkdir ENV['HOME']+'/assets' }  
end

dep 'cb proj from git repo' do
  requires 'cb github in known hosts'
  met? { grep var(:git_repo), ENV['HOME']+'/current/.git/config' }
  meet { shell "git clone #{var(:git_repo)} #{ENV['HOME']}/current" }  
end
