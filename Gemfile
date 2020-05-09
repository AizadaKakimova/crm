source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
ruby '2.5.1'
gem 'rails', '~> 5.1.6'
gem 'pg', '>= 0.18', '< 2.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 4.0'
gem 'bcrypt', '~> 3.1.7'
gem 'jwt_sessions', '~> 2'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rack-cors',:require => 'rack/cors'
gem 'friendly_id', '~> 5.2.0'
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'rails-i18n'
gem 'grape'
gem 'kaminari'
gem 'api-pagination'
gem 'acts_as_tenant'
gem 'passenger'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.7', '>= 3.7.1'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano3-puma'
  # gem 'capistrano-passenger', '~> 0.2.0'
end

group :production do
  gem 'capistrano-passenger'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
