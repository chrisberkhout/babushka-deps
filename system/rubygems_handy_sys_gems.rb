dep 'rubygems handy sys gems' do
  requires \
    'gem rake',
    'gem rubyforge',
    'gem gemcutter',
    'gem ghost'
end


dep 'gem rake' do
  requires 'rubygems installed somehow'
  met? { `gem list rake`.include?('rake ') && `rake --version 2>&1`.include?('rake, version ') }
  meet { sudo "gem install rake" }
end

dep 'gem rubyforge' do
  requires 'rubygems installed somehow';
  met? { `gem list rubyforge`.include?('rubyforge ') }
  meet { sudo "gem install rubyforge" }
end

dep 'gem gemcutter' do
  requires 'rubygems installed somehow'
  met? { `gem list gemcutter`.include?('gemcutter ') }
  meet { sudo "gem install gemcutter" }
end

dep 'gem ghost' do
  requires 'rubygems installed somehow'
  met? { `gem list ghost`.include?('ghost ') }
  meet { sudo "gem install ghost" }
end
