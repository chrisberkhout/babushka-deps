require 'etc' 

def owner_and_group?(file, user_and_group)
  user, group = user_and_group.split(':')
  Etc.getpwuid(File.stat(file).uid).name == user &&
  Etc.getgrgid(File.stat(file).gid).name == group
end

def perms?(file, perms)
  sprintf("%o", File.stat(File.expand_path(file)).mode)[-3..-1] == perms
end

def dir_empty?(dir, opts = {})
  `#{opts[:sudo] ? 'sudo ' : ''} ls #{dir}`[/^$/]
end
