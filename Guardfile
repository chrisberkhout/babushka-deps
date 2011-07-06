guard 'shell' do
  watch(%r{^[^\.]}) do
    `git add . && git commit -m "... autobabs at #{Time.now}." && git update-server-info`
  end
end
