require 'spec_helper'

describe 'testguide', :type => :class do
  let(:params) { { :world => 'Kitty!' } }

  it do
    should contain_file('/tmp/some/useless/directory/hello.txt') \
      .with_content("Hello Kitty!\n")
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
