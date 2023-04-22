require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  # describe 'Swagger UI engine' do
  #   it 'routes to the Swagger UI engine' do
  #     expect(get: '/api-docs').to route_to('swagger_ui_engine/docs#index')
  #   end
  # end

  # describe 'Error pages' do
  #   it 'routes to the not found page' do
  #     expect(get: '/404').to route_to('errors#not_found')
  #   end

  #   it 'routes to the internal server error page' do
  #     expect(get: '/500').to route_to('errors#internal_server_error')
  #   end
  # end

  describe 'Talent routes' do
    it 'routes to the talents index page' do
      expect(get: '/talents').to route_to('talents#index')
    end

    it 'routes to the talents show page' do
      expect(get: '/talents/1').to route_to('talents#show', id: '1')
    end

    it 'routes to the talents create page' do
      expect(post: '/talents').to route_to('talents#create')
    end

    it 'routes to the talents update page' do
      expect(put: '/talents/1').to route_to('talents#update', id: '1')
    end

    it 'routes to the talents destroy page' do
      expect(delete: '/talents/1').to route_to('talents#destroy', id: '1')
    end
  end

  # Repeat for other resource routes
end
