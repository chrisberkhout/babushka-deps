dep 'cb system' do
    requires 'cb system base'
end

dep 'cb system base' do
  requires \
    'cb ubuntu karmic 9.10 or later', # just because that's what I have been writing my deps on
    'cb admin group',
    'cb time setup',
    'cb ssh server',
    'cb known hosts',
    'cb handy sys packages',
    'cb ruby',
    'cb rubygems',
    'cb rubygems handy sys gems',
    'cb nginx'
end
