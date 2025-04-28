# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.paths << Rails.root.join("node_modules")
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")

Rails.application.config.assets.precompile += %w( tailwind.css )

# Configure Sprockets to handle modern CSS syntax
Rails.application.config.assets.configure do |env|
  env.register_mime_type 'text/tailwindcss', extensions: ['.tailwind.css']
  env.register_preprocessor 'text/tailwindcss', Sprockets::DirectiveProcessor.new(comments: ["//", ["/*", "*/"]])
  
  # Skip Sass processing for Tailwind files
  env.register_bundle_processor 'text/tailwindcss', Sprockets::Bundle
end
