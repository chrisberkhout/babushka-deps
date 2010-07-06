dep 'cb proj from git repo' do
  requires 'cb github in known hosts'

  met? { 
    grep var(:git_repo), ENV['HOME']+'/current/.git/config'
  }
  meet {
    shell "git clone #{var(:git_repo)} #{ENV['HOME']}/current"
  }
  
end
