source 'https://rubygems.org'

gem 'berkshelf'
gem 'coveralls', require: false
gem 'rubocop', '0.33.0'
gem 'chef-handler-profiler'
gem 'chef-handler-opsmatic'
gem 'chef-handler-datadog'

group :development do
  gem 'guard'
  gem 'guard-kitchen'
  gem 'guard-foodcritic', '>= 1.0'
  gem 'foodcritic', '>= 3.0'
  gem 'chefspec', '>= 3.1'
end

group :integration do
  gem 'serverspec'
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-ec2'
end
