dep 'system' do
    requires 'system base'
end

dep 'system base' do
  requires \
    'ubuntu karmic 9.10 or later', # just because that's what I have been writing my deps on
    'admin group',
    'time setup',
    'ssh server',
    'known hosts',
    'handy sys packages',
    'ruby',
    'rubygems',
    'rubygems handy sys gems',
    'nginx'
end
