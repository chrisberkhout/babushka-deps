dep 'system' do
    requires 'system base'
end

dep 'system base' do
  requires \
    'ubuntu lucid 10.04 or later', # just because that's what I have been writing my deps on
    'admin group',
    'time setup',
    'mdns',
    'ssh server',
    'known hosts',
    'handy sys packages',
    'rvm system ree default'
end
