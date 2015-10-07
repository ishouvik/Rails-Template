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
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-livereload'
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
gem 'jquery-turbolinks'
gem 'google-webfonts-rails'

# Authentication
gem 'devise'

# Authorization
gem 'cancan'
gem 'rolify'

# Misc
gem 'carrierwave'
gem 'rmagick'
gem 'kaminari'
gem 'simple_form'
gem 'nested_form'


after_bundle do
	copy_file 'Guardfile'
	puts "\n================ GUARDFILE PLACED ================\n"


	generate 'controller home index'
	route "root to: 'home#index'"

	inside 'app/controllers' do
		remove_file 'application_controller.rb'
		copy_file 'application_controller.rb'
	end
	puts "\n================ CONTROLLERS SETUP COMPLETE ================\n"

	generate 'simple_form:install --bootstrap'
	puts "\n================ SIMPLE FORM BOOTSTRAP SETUP COMPLETE ================\n"


	generate 'devise:install'
	generate 'devise User'
	insert_into_file 'config/environments/development.rb', after: "Rails.application.configure do\n" do <<-RUBY
		config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
	RUBY
	end
	generate 'migration AddFieldsToUsers avatar:string username:string:uniq:index name:string'
	generate 'devise:views'
	puts "\n================ DEVISE SETUP COMPLETE ================\n"


	generate 'rolify Role User'
	puts "\n================ ROLIFY ADDED TO USER MODEL ================\n"

	inside 'app/models' do
		# Cancan ability
		copy_file 'ability.rb'
		puts "\n================ CANCAN ABILITY GENERATED ================\n"

		remove_file 'user.rb'
		copy_file 'user.rb'
		puts "\n================ USER MODEL RECONFIGURED ================\n"		
	end

	# inside 'db' do
	# 	# remove_file 'seeds.rb'
	# 	copy_file 'seeds.rb', :force => true
	# 	puts "\n================ SEED DATABA GENERATED ================\n"
	# end


	inside 'config' do
		# Locales
		insert_into_file 'locales/en.yml', after: "en:\n" do <<-RUBY
		site:
		 name: 'Rails 4 App'
		 headline: 'Created using iShouvik Rails Template'
		 description: 'This is an example Rails app generated with iShouvik Rails Template. Please, feel free to make modifications as you wish'
		 nocontent: 'Oops, nothing to show here yet!'
		RUBY
		end
		
		# Database
		remove_file 'database.yml'
		copy_file 'database.yml'

		# Puma
		copy_file 'puma.rb'

		# CarrierWave
		copy_file 'initializers/carrierwave.rb'

		puts "\n================ CONFIG FILES GENERATED ================\n"
	end

	# Uploaders
	inside 'app/uploaders' do
		copy_file 'image_uploader.rb'
		puts "\n================ UPLOADERS GENERATED ================\n"
	end 


	generate 'bootstrap:install static'

	puts "\n================ BOOTSTRAP INSTALLED =================\n"

	inside 'app/assets/stylesheets' do
		copy_file 'main.scss'
		insert_into_file 'application.css', after: "*= require_tree .\n" do
			" *= main\n"
		end
	end
	inside 'app/assets/javascripts' do
		insert_into_file 'application.js', after: "//= require jquery\n" do
			"//= require jquery.turbolinks\n"
		end
		insert_into_file 'application.js', after: "//= require jquery.turbolinks\n" do
			"//= require jquery_nested_form\n"
		end
	end
	puts "\n================ ASSET FILES UPDATED ================\n"


	rake 'assets:precompile'
	rake 'db:setup'
	rake 'db:migrate'
	rake 'db:seed'
	puts "\n================ RAKE TASKS COMPLETE ================\n"

	inside 'app/views/layouts' do
		# copy_file 'application.html.erb', :force => true
		copy_file '_foot.html.erb'
		copy_file '_footer.html.erb'
		copy_file '_head.html.erb'
		copy_file '_main_nav.html.erb'
		copy_file '_modal_dialog.html.erb'
		copy_file '2-col-rightsidebar.html.erb'
		copy_file '2-col-leftsidebar.html.erb'
		copy_file 'blank.html.erb'
		copy_file 'full-width.html.erb'
		copy_file 'one-col.html.erb'
		
	end
	puts "\n================ LAYOUT FILES COPIED ================\n"

	git :init
	git add: "."
	git commit: "-a -m 'Initial commit'"
	puts "\n================ GIT INITIALISED ================\n"
end