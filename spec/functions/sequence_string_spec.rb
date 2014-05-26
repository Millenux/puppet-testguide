require 'spec_helper'

describe 'sequence_string' do
  describe 'when called only with a single string parameter' do
    it do
      should run.with_params('/this/is/a/test').and_return(['/','/this/','/this/is/','/this/is/a/','/this/is/a/test']) 
    end
  end

  describe 'when called with a string and a separator' do
    it do
      should run.with_params('!this!is!a!test','!').and_return(['!','!this!','!this!is!','!this!is!a!','!this!is!a!test']) 
    end
  end

  describe 'when called with a string, separator and a prefix' do
    it do
      should run.with_params('!this!is!a!test','!','!tmp').and_return(['!tmp!','!tmp!this!','!tmp!this!is!','!tmp!this!is!a!','!tmp!this!is!a!test']) 
    end
  end
end

