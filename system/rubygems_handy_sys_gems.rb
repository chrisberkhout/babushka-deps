dep 'cb rubygems handy sys gems' do
  requires \
    'cb rubygems',
    'cb gem rake',
    'cb gem rubyforge',
    'cb gem gemcutter',
    'cb gem ghost'
end


dep 'cb gem rake' do
  requires 'cb rubygems'
  met? { `gem list rake`.include?('rake ') && `rake --version 2>&1`.include?('rake, version ') }
  meet { sudo "gem install rake" }
end

dep 'cb gem rubyforge' do
  requires 'cb rubygems'; met? { `gem list rubyforge`.include?('rubyforge ') }; meet { sudo "gem install rubyforge" }
end

dep 'cb gem gemcutter' do
  requires 'cb rubygems'; met? { `gem list gemcutter`.include?('gemcutter ') }; meet { sudo "gem install gemcutter" }
end

dep 'cb gem ghost' do
  requires 'cb rubygems'; met? { `gem list ghost`.include?('ghost ') }; meet { sudo "gem install ghost" }
end
