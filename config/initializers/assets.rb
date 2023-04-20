Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets')
Rails.application.config.assets.precompile += %w( *.css )
