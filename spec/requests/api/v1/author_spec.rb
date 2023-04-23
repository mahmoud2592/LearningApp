require 'swagger_helper'

RSpec.describe AuthorsController, type: :request do
  describe 'Authors API' do
    path '/authors' do
      get 'Retrieves a list of authors' do
        tags 'Authors'
        produces 'application/json'
        parameter name: :page, in: :query, type: :integer, description: 'Page number'
        parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'

        response '200', 'authors found' do
          schema type: :array,
                items: { '$ref' => '#/definitions/author' }

          let(:page) { 1 }
          let(:per_page) { 10 }
          run_test!
        end

        response '404', 'authors not found' do
          let(:page) { 100 }
          let(:per_page) { 10 }
          run_test!
        end
      end

      post 'Creates an author' do
        tags 'Authors'
        consumes 'application/json'
        parameter name: :author, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            email: { type: :string },
            website_url: { type: :string }
          },
          required: [ 'name', 'email' ]
        }

        response '201', 'author created' do
          let(:author) { { name: 'John Doe', email: 'john@example.com' } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:author) { { name: 'John Doe' } }
          run_test!
        end
      end
    end

    path '/authors/{id}' do
      parameter name: :id, in: :path, type: :integer

      get 'Retrieves an author' do
        tags 'Authors'
        produces 'application/json'

        response '200', 'author found' do
          schema '$ref' => '#/definitions/author'

          let(:id) { create(:author).id }
          run_test!
        end

        response '404', 'author not found' do
          let(:id) { -1 }
          run_test!
        end
      end

      put 'Updates an author' do
        tags 'Authors'
        consumes 'application/json'
        parameter name: :author, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            email: { type: :string },
            website_url: { type: :string }
          }
        }

        response '200', 'author updated' do
          let(:id) { create(:author).id }
          let(:author) { { name: 'Jane Doe' } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:id) { create(:author).id }
          let(:author) { { email: '' } }
          run_test!
        end

        response '404', 'author not found' do
          let(:id) { -1 }
          let(:author) { { name: 'Jane Doe' } }
          run_test!
        end
      end

      

      delete 'Delete an Author' do
        tags 'Authors'
        produces 'application/json'
        consumes 'application/json'
        parameter name: :id, in: :path, type: :integer
  
        response '204', 'Author deleted' do
          run_test! do
            expect(response).to have_http_status(:no_content)
          end
        end
  
        response '404', 'Author not found' do
          let(:id) { 'invalid' }
          run_test! do
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
    end
  end