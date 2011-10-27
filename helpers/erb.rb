require 'erb'

def changed_from_erb?(destination_file, source_erb)
  !File.exist?(destination_file) ||
  IO.read(destination_file) != ERB.new(IO.read(erb_path_for(source_erb))).result(binding)
end

# This is my way of rendering partials
def render_erb_inline(file, opts = {})
  if File.exist?(erb_path_for(file))
    ERB.new(IO.read(erb_path_for(file))).result(binding).gsub(/\n/, "\n#{sprintf("%#{opts[:indent]}s", "")}").strip
  else
    raise "Can't do an inline render of '#{file}' because it doesn't exist!"
  end
end

# This is based on Ben's old #render_erb
def my_render_erb erb, opts = {}
  if (path = erb_path_for(erb)).nil?
    log_error "If you use #my_render_erb within a dynamically defined dep, you have to give the full path to the erb template."
  elsif !File.exists?(path) && !opts[:optional]
    log_error "Couldn't find erb to render at #{path}."
  elsif File.exists?(path)
    # require 'erb'
    debug ERB.new(IO.read(path)).result(binding)
    shell("cat > #{opts[:to]}",
      :input => ERB.new(IO.read(path)).result(binding),
      :sudo => opts[:sudo]
    ) do |result|
      if result
        log "Rendered #{opts[:to]}."
        sudo "chmod #{opts[:perms]} '#{opts[:to]}'" unless opts[:perms].nil?
      else
        log_error "Couldn't render #{opts[:to]}."
      end
    end
  end
end
