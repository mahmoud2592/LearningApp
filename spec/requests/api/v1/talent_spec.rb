require 'swagger_helper'

RSpec.describe TalentsController, type: :request do
  path '/talents' do
    get 'Retrieves all talents' do
      tags 'Talents'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'talents found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              category: { type: :string },
              level: { type: :string },
              website_url: { type: :string }
            },
            required: [ 'id', 'name', 'description', 'category', 'level' ]
          }
        let(:page) { 1 }
        let(:per_page) { 10 }
        run_test!
      end

      response '404', 'talents not found' do
        let(:page) { 99999 }
        let(:per_page) { 10 }
        run_test!
      end
    end

    post 'Creates a talent' do
      tags 'Talents'
      consumes 'application/json'
      parameter name: :talent, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          category: { type: :string },
          level: { type: :string },
          website_url: { type: :string }
        },
        required: [ 'name', 'description', 'category', 'level' ]
      }

      response '201', 'talent created' do
        let(:talent) { { name: 'New Talent', description: 'Talent description', category: 'Web Development', level: 'Intermediate' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:talent) { { name: nil, description: 'Talent description', category: 'Web Development', level: 'Intermediate' } }
        run_test!
      end
    end
  end

  path '/talents/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a talent' do
      tags 'Talents'
      produces 'application/json'
      response '200', 'talent found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            category: { type: :string },
            level: { type: :string },
            website_url: { type: :string }
          },
          required: [ 'id', 'name', 'description', 'category', 'level' ]
        let(:id) { Talent.create(name: 'New Talent', description: 'Talent description', category: 'Web Development', level: 'Intermediate').id }
        run_test!
      end

      response '404', 'talent not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch 'Updates a talent' do
        tags 'Talents'
        consumes 'application/json'
        parameter name: :talent, in: :body,
          schema: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              category: { type: :string },
              level: { type: :string },
              website_url: { type: :string }
            },
            required: ['name', 'description', 'category', 'level', 'website_url']
          }
  
        response '200', 'talent updated' do
          let(:talent) { { name: 'Updated Talent Name' } }
          let(:id) { Talent.create(name: 'Test Talent', description: 'This is a test talent', category: 'Test', level: 'Intermediate', website_url: 'http://test.com').id }
          run_test!
        end
  
        response '422', 'invalid request' do
          let(:talent) { { name: nil } }
          let(:id) { Talent.create(name: 'Test Talent', description: 'This is a test talent', category: 'Test', level: 'Intermediate', website_url: 'http://test.com').id }
          run_test!
        end
  
        response '404', 'talent not found' do
          let(:talent) { { name: 'Updated Talent Name' } }
          let(:id) { 'invalid' }
          run_test!
        end
      end
  
      delete 'Deletes a talent' do
        tags 'Talents'
        produces 'application/json'
  
        response '204', 'talent deleted' do
          let(:id) { Talent.create(name: 'Test Talent', description: 'This is a test talent', category: 'Test', level: 'Intermediate', website_url: 'http://test.com').id }
          run_test!
        end
  
        response '404', 'talent not found' do
          let(:id) { 'invalid' }
          run_test!
        end
      end
    end
end