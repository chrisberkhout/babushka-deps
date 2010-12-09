require 'erb'

def changed_from_erb?(destination_file, source_erb)
  !File.exist?(destination_file) ||
  IO.read(destination_file) != ERB.new(IO.read(erb_path_for(source_erb))).result(binding)
end

def render_erb_inline(file)
  File.exist?(erb_path_for(file)) &&
  ERB.new(IO.read(erb_path_for(file))).result(binding)
end
