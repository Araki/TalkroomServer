source 'https://rubygems.org'

gem 'rails', '3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
group :development do
  #gem 'mysql', '2.9.1'
  gem 'mysql2'
  #gem "activerecord-jdbcmysql-adapter"
end
#gem 'pg', groups: %w(production), require:false

gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

#herokuにデプロイしたら動かない
#こちらの記事を参考にhttp://fujitaiju.com/blog/technology/ruby/ruby-on-rails/railsheroku%E3%81%ABrails3-1%E3%81%AE%E3%82%A2%E3%83%97%E3%83%AA%E3%82%92%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%E3%81%97%E3%81%9F%E3%82%89%E3%83%8F%E3%83%9E%E3%82%8A%E3%81%BE%E3%81%8F%E3%81%A3/
group :production do
  #gem 'mysql'#, '2.9.1'
  gem 'mysql2'#, "~> 0.3.11"
  
  #jdbcmysql削除
  #gem "activerecord-jdbcmysql-adapter"
  gem 'therubyracer-heroku', '0.8.1.pre3' # you will need this too

end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'venice'
