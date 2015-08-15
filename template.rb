# Add the current directory to the path Thor uses
# to look up files
def source_paths
  Array(super) + 
    [File.expand_path(File.dirname(__FILE__))]
end

# We'll be building the Gemfile from scratch
remove_file "Gemfile"
run "touch Gemfile"

add_source 'https://rubygems.org'

insert_into_file 'Gemfile', "\nruby '2.2.1'", after: "source 'https://rubygems.org'\n"

gem 'rails', '4.2.3'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc


gem_group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'sqlite3'
end

gem_group :production do
	gem 'rails_12factor'
	gem 'mysql2'
	gem 'puma'
	gem 'fog'
end

# Frontend Lib
gem "therubyracer"
gem "twitter-bootstrap-rails"
gem 'bootstrap-datepicker-rails'
gem "select2-rails" # jQuery based replacement for select boxes
gem 'jquery-turbolinks'
gem 'google-webfonts-rails' # Google webfonts

# Authentication
gem 'devise'

# Authorization
gem 'cancan'
gem 'rolify'

# Misc
gem 'carrierwave'
gem 'rmagick'
gem 'kaminari'
# gem 'acts-as-taggable-on', '~> 3.4'
gem 'nested_form'


after_bundle do
	generate 'controller home index'
	route "root to: 'home#index'"
	puts "\n================ APP ROOT GENERATED ================\n"


	generate 'devise:install'
	generate 'devise User'
	insert_into_file 'config/environments/development.rb', after: "Rails.application.configure do\n" do <<-RUBY
		"config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }"
	RUBY
	end
	generate 'migration AddFieldsToUsers username:string:uniq:index name:string'
	puts "\n================ DEVISE SETUP COMPLETE ================\n"


	generate 'rolify Role User'
	puts "\n================ ROLIFY ADDED TO USER MODEL ========"

	inside 'app/models' do
		# Cancan ability
		copy_file 'ability.rb'
		puts "\n================ CANCAN ABILITY GENERATED ========"

		remove_file 'user.rb'
		copy_file 'user.rb'
		puts "\n================ USER MODEL RECONFIGURED ========"		
	end

	inside 'db' do
		remove_file 'seeds.rb'
		copy_file 'seeds.rb'		
		puts "\n================ SEED DATA GENERATED ================"
	end


	inside 'config' do
		remove_file 'database.yml'
		copy_file 'database.yml'
		puts "\n================ DB CONFIG GENERATED ================"

		# Puma
		copy_file 'puma.rb'
		puts "\n================ PUMA CONFIG GENERATED ================"

		# CarrierWave
		copy_file 'initializers/carrierwave.rb'
		puts "\n================ CARRIERWAVE INITIALISED ================\n"

	end

	# Uploaders
	inside 'app/uploaders' do
		copy_file 'image_uploader.rb'
		puts "\n================ IMAGE UPLOADER GENERATED ================\n"
	end 

	rake 'db:setup'
	puts "\n================ DB SETUP COMPLETE ================\n"


	git :init
	git add: "."
	git commit: "-a -m 'Initial commit'"
	puts "\n================ GIT INITIALISED ================\n"
end