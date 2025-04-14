source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.2.2"

# Core gems
gem "rails", "~> 7.1.0"
gem "pg", "~> 1.5"
gem "puma", "~> 6.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Frontend
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 3.3.1"
gem "sassc-rails"
gem "jquery-rails"

# Authentication
gem "devise"

# Background jobs
gem "delayed_job_active_record"

# Monitoring
gem "honeybadger"
gem "skylight"

# Utilities
gem "rack-canonical-host"
gem "recipient_interceptor"
gem "title"
gem "simple_form"

group :development do
  gem "web-console"
  gem "rack-mini-profiler", require: false
  gem "spring"
  gem "listen"
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "dotenv-rails"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "bullet"
  gem "pry-byebug"
  gem "pry-rails"
  gem "bundler-audit", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "database_cleaner-active_record"
  gem "formulaic"
  gem "launchy"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
  gem "shoulda-matchers"
end
