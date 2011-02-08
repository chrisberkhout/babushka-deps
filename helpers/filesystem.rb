require 'etc' 

def owner_and_group?(file, user_and_group)
  user, group = user_and_group.split(':')
  Etc.getpwuid(File.stat(file).uid).name == user &&
  Etc.getgrgid(File.stat(file).gid).name == group
end

def dir_empty?(dir, opts = {})
  `#{opts[:sudo] ? 'sudo ' : ''} ls #{dir}`[/^$/]
end
