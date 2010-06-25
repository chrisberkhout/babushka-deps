require 'erb'

def changed_from_erb?(destination_file, source_erb)
  IO.read(destination_file) != ERB.new(IO.read(erb_path_for(source_erb))).result(binding)
end
