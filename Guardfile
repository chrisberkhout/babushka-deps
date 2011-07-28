guard 'shell' do
  # Issues:
  # - doesn't git-rm deleted files
  # - ignores all .* files instead of .git/ specifically
  # - (something I forget, about doing things concurrently... maybe manual vs auto commits)
  watch(%r{^[^\.]}) do
    `git add . && git commit -m "... autobabs at #{Time.now}." && git update-server-info`
  end
end
