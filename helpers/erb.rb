require 'erb'

def changed_from_erb?(destination_file, source_erb)
  !File.exist?(destination_file) ||
  IO.read(destination_file) != ERB.new(IO.read(erb_path_for(source_erb))).result(binding)
end

def render_erb_inline(file, opts = {})
  if File.exist?(erb_path_for(file))
    puts "=====plain"
    puts ERB.new(IO.read(erb_path_for(file))).result(binding)
    puts "=====gsub"
    puts ERB.new(IO.read(erb_path_for(file))).result(binding).gsub(/\n/, "\n#{sprintf("%#{opts[:indent]}s", "")}")
    puts "=====gsub.trim"
    puts ERB.new(IO.read(erb_path_for(file))).result(binding).gsub(/\n/, "\n#{sprintf("%#{opts[:indent]}s", "")}").strip
    ERB.new(IO.read(erb_path_for(file))).result(binding).gsub(/\n/, "\n#{sprintf("%#{opts[:indent]}s", "")}").strip
  else
    raise "Can't do an inline render of '#{file}' because it doesn't exist!"
  end
end
