source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['~> 2.7']
end

gem 'puppet', puppetversion, :require => false
gem 'puppet-lint'
gem 'rake'
