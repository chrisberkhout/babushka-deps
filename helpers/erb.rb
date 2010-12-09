require 'erb'

def changed_from_erb?(destination_file, source_erb)
  !File.exist?(destination_file) ||
  IO.read(destination_file) != ERB.new(IO.read(erb_path_for(source_erb))).result(binding)
end

def render_erb_inline(file, opts = {})
  if File.exist?(erb_path_for(file)) do
    lines = ERB.new(IO.read(erb_path_for(file))).result(binding).split("\n")
    [1..(lines.length-1)].each { |i| lines[i] = sprintf("%#{opts[:indent]}s", "") + lines[i] } if lines.length > 1
  else
    raise "Can't do an inline render of '#{file}' because it doesn't exist!"
  end
end
