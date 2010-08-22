def suck_env(input, selection)
  # input is a string or array ending with lines of environment variables and values separated by '='
  # selection is an array of the environment variables you want to suck up from the input
  # e.g. suck_env(`some_cmd; echo; env`, ['PATH', 'MANPATH'])
  # inspired by: http://stackoverflow.com/questions/1197224/source-shell-script-into-environment-within-a-ruby-script
  lines = input.kind_of?(Array) ? input.map{|e| e.chomp} : input.split("\n")
  sucked_env = {}
  lines.reverse.each { |l|
    if l.match(/^(\w+)\=(.*)$/)
      sucked_env[$1] = $2
    else
      break
    end
  }
  sucked_env.each_pair{ |k,v| ENV[k] = v if selection.include?(k) }
end
