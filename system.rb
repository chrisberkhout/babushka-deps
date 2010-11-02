dep 'system' do
    requires 'system base'
end

dep 'system base' do
  requires \
    'ubuntu 10.04 or later', # just because that's what I have been writing my deps on
    'admin group',
    'time setup',
    'ssh server',
    'known hosts',
    'handy sys packages',
    'rvm system default ree',
    'rubygems sources',           # ! possible problem here (should be different for rvm rubygems)
    'rubygems handy sys gems',    # ! possible problem here (should be different for rvm rubygems)
    'nginx'
end
