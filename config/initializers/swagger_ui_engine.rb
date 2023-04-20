SwaggerUiEngine.configure do |config|
  config.swagger_url = {
    v1: '/swagger_docs/v1/swagger.json'
  }
  config.doc_expansion = 'list'
end
