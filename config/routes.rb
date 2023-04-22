Rails.application.routes.draw do
  mount SwaggerUiEngine::Engine, at: '/api-docs'
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :talents
  resources :authors
  resources :learning_paths
  resources :courses
  resources :enrollments
  resources :course_talents
end
