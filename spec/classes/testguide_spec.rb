require 'spec_helper'

describe 'testguide', :type => :class do
  let(:params) { { :world => 'kitty' } }

  it do
    should contain_file('/tmp/some/useless/directory/hello.txt') \
      .with_content('Hello kitty!')
  end

  it do
    should contain_file('/tmp/some/')
  end
  it do
    should contain_file('/tmp/some/useless/')
  end
  it do
    should contain_file('/tmp/some/useless/directory')
  end
end
