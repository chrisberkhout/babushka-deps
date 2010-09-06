dep 'rubygems sources' do
  requires \
    'rubygems source rubyforge',
    'rubygems source gemcutter',
    'rubygems source github'
end


dep 'rubygems source rubyforge' do
  # http://update.gemcutter.org/2009/10/26/transition.html
  requires 'rubygems installed somehow'
  met? { `gem sources`.include?('http://gems.rubyforge.org/') }
  meet { sudo "gem sources --add http://gems.rubyforge.org/" }
end

dep 'rubygems source gemcutter' do
  # http://update.gemcutter.org/2009/10/26/transition.html
  requires 'rubygems installed somehow'
  met? { `gem sources`.include?('http://gemcutter.org') }
  meet { sudo "gem sources --add http://gemcutter.org" }
end

dep 'rubygems source github' do
  # http://github.com/blog/515-gem-building-is-defunct
  requires 'rubygems installed somehow'
  met? { `gem sources`.include?('http://gems.github.com') }
  meet { sudo "gem sources --add http://gems.github.com" }
end
