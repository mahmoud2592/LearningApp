class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Use the ImageProcessing gem for image processing
  has_one_attached :image

  # Use the Kaminari gem for pagination
  paginates_per 25

  # # Use the Rack CORS gem for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
  # include Rack::Cors

  # Use the Rails-i18n gem for internationalization support
  # include Rails::I18n
# These lines of code are commented out, which means they are not currently being used in the application. However, they
# suggest that the Shoulda Matchers gem and Swagger UI Engine gem were potentially considered for use in the application
# for testing Rails applications and API documentation, respectively.

  # # Use the Shoulda Matchers gem for testing Rails applications
  # include Shoulda::Matchers::ActiveRecord

  # # Use the Swagger UI Engine gem for API documentation
  # include SwaggerUiEngine::Concerns::Apiable
end
