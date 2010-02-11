dep 'rubygems handy sys gems' do
  requires \
    'gem rake',
    'gem rubyforge',
    'gem gemcutter',
    'gem rspec',
    'gem cucumber',
    'gem ghost'
end


dep 'gem rake' do
  requires 'rubygems'
  met? { `gem list rake`.include?('rake ') && `rake --version 2>&1`.include?('rake, version ') }
  meet { sudo "gem install rake" }
end

dep 'gem rubyforge' do
  requires 'rubygems'; met? { `gem list rubyforge`.include?('rubyforge ') }; meet { sudo "gem install rubyforge" }
end

dep 'gem gemcutter' do
  requires 'rubygems'; met? { `gem list gemcutter`.include?('gemcutter ') }; meet { sudo "gem install gemcutter" }
end

dep 'gem rspec' do
  requires 'rubygems'; met? { `gem list rspec`.include?('rspec ') }; meet { sudo "gem install rspec" }
end

dep 'gem cucumber' do
  requires 'rubygems'; met? { `gem list cucumber`.include?('cucumber ') }; meet { sudo "gem install cucumber" }
end

dep 'gem ghost' do
  requires 'rubygems'; met? { `gem list ghost`.include?('ghost ') }; meet { sudo "gem install ghost" }
end
