#things we'll want to do with our template
# rails -m {PATH_TO_TEMPLATE}
# TODO:
# Rename application.html.erb to application.html.haml

gem 'compass-rails', :group => :assets
gem 'haml-rails'

# make rails generate sass files instead of scss.
inject_into_file 'config/application.rb', after: "config.encoding = \"utf-8\"\n\n" do <<-'RUBY'
    # Generate sass instead of scss
    config.sass.preferred_syntax = :sass

RUBY
end

# Now create a new compass project (it will be sass not scss)
run 'compass create .'

# remove print and ie stylesheets because really who uses those.
run 'rm app/assets/stylesheets/print.css.sass'
run 'rm app/assets/stylesheets/ie.css.sass'

# grab jQuery
get "https://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js", "app/assets/javascripts/jquery.js"

# Let the people create a controller if the want. 
if yes?("Do you want to generate a controller?")
  controller_name = ask("What do you want to call your controller?")
  generate("controller", controller_name, "index")

  # If they do remove static home pages
  run "rm public/index.html"
  # And replace it with the newly generated page
  inject_into_file 'config/routes.rb', after: "# root :to => 'welcome#index'\n" do <<-'RUBY'
      root to: 'pages#index'
  RUBY
  end
end

# Set up a git repo and commit everything
git :init
git :add => '.'
git :commit => "-m 'Initial commit'"
