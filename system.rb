dep 'cb system' do
  requires \
    'cb ubuntu karmic 9.10 or later', # just because that's what I have been writing my deps on
    'cb time setup',
    'cb ssh server',
    'cb handy sys packages',
    'cb ruby',
    'cb rubygems',
    'cb rubygems handy sys gems',
    'cb nginx'
end
