# To use run:
# rails new {Your app name}  -m {PATH_TO_TEMPLATE}

# make rails generate sass files instead of scss.
inject_into_file 'config/application.rb', after: "config.encoding = \"utf-8\"\n\n" do <<-'RUBY'
    # Generate sass instead of scss
    config.sass.preferred_syntax = :sass

RUBY
end

gem 'haml-rails'
gem 'compass-rails'
run 'bundle install'

run "touch app/assets/stylesheets/styles.sass"
run 'rm app/views/layouts/application.html.erb'

create_file "app/views/layouts/application.haml" do <<-'FILE'
!!!
%html
  %head
    %title Project Template Title
    = stylesheet_link_tag    "application", :media => "all"
    = csrf_meta_tags
  %body
    .main-content
      = yield
      %script{src: "https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"}
    = javascript_include_tag "application"
FILE
end

# Install annimation keyframes mixin?
if yes?("Do you want to pull in a keyframe mixin?")
get "https://raw.github.com/jpschwinghamer/static-template/master/sass/_animations.sass", "app/assets/stylesheets/_animations.sass"
get "https://raw.github.com/jpschwinghamer/static-template/master/sass/_keyframes.sass", "app/assets/stylesheets/_keyframes.sass"
append_file "app/assets/stylesheets/styles.sass" do <<-'FILE'
@import animations
FILE
end
end

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
