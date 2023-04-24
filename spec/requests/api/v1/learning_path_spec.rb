require 'swagger_helper'

RSpec.describe LearningPathsController, type: :request do
    path '/learning_paths' do
        get 'Returns a list of learning paths' do
          tags 'Learning Paths'
          produces 'application/json'
          parameter name: :difficulty_level, in: :query, type: :string, description: 'Filter by difficulty level'
          parameter name: :published, in: :query, type: :boolean, description: 'Filter by published'
          parameter name: :q, in: :query, type: :string, description: 'Filter by search query'
          parameter name: :sort, in: :query, type: :string, description: 'Sort by views count'
          parameter name: :page, in: :query, type: :integer, description: 'Page number'
          parameter name: :per_page, in: :query, type: :integer, description: 'Number of items per page'

          response '200', 'returns a list of learning paths' do
            schema type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  description: { type: :string },
                  duration_in_weeks: { type: :integer },
                  difficulty_level: { type: :string, enum: %w[beginner intermediate advanced expert] },
                  published: { type: :boolean },
                  views_count: { type: :integer }
                },
                required: ['id', 'name', 'description', 'duration_in_weeks', 'difficulty_level', 'published', 'views_count']
              }
            run_test!
          end

          response '422', 'invalid request' do
            schema type: :object,
              properties: {
                error: {
                  type: :string
                }
              },
              required: ['error']

            let(:difficulty_level) { 'invalid' }
            run_test!
          end
        end
      end
    path '/learning_paths/{id}' do
        get 'Retrieves a learning path' do
          tags 'Learning Paths'
          produces 'application/json'
          parameter name: :id, in: :path, type: :string

          response '200', 'learning path found' do
            schema '$ref' => '#/components/schemas/LearningPath'
            let(:learning_path) { create(:learning_path) }
            let(:id) { learning_path.id }
            run_test!
          end

          response '404', 'learning path not found' do
            let(:id) { 'invalid' }
            run_test!
          end
        end

        delete 'Deletes a learning path' do
          tags 'Learning Paths'
          produces 'application/json'
          parameter name: :id, in: :path, type: :string

          response '204', 'learning path deleted' do
            let(:learning_path) { create(:learning_path) }
            let(:id) { learning_path.id }
            run_test!
          end

          response '404', 'learning path not found' do
            let(:id) { 'invalid' }
            run_test!
          end
        end
    end
    describe 'Learning Paths API' do
        path '/learning_paths' do
          post 'Creates a learning path' do
            tags 'Learning Paths'
            consumes 'application/json'
            parameter name: :learning_path, in: :body, schema: {
              type: :object,
              properties: {
                name: { type: :string },
                description: { type: :string },
                duration_in_weeks: { type: :integer },
                difficulty_level: { type: :string, enum: %w[beginner intermediate advanced expert], required: true },
                published: { type: :boolean },
                views_count: { type: :integer }
              },
              required: [ 'name', 'description', 'duration_in_weeks', 'difficulty_level', 'published' ]
            }

            response '201', 'learning path created' do
              let(:learning_path) { { name: 'Learn Ruby', description: 'A beginner\'s guide to Ruby programming', duration_in_weeks: 4, difficulty_level: 'Beginner', published: true } }
              run_test!
            end

            response '422', 'invalid request' do
              let(:learning_path) { { name: 'Learn Ruby', description: 'A beginner\'s guide to Ruby programming', duration_in_weeks: 4, difficulty_level: 'Beginner', published: 'yes' } }
              run_test!
            end
          end
        end

        path '/learning_paths/{id}' do
          put 'Updates a learning path' do
            tags 'Learning Paths'
            consumes 'application/json'
            parameter name: :id, in: :path, type: :integer
            parameter name: :learning_path, in: :body, schema: {
              type: :object,
              properties: {
                name: { type: :string },
                description: { type: :string },
                duration_in_weeks: { type: :integer },
                difficulty_level: { type: :string, enum: %w[beginner intermediate advanced expert], required: true },
                published: { type: :boolean },
                views_count: { type: :integer }
              }
            }

            response '200', 'learning path updated' do
              let(:id) { LearningPath.create(name: 'Learn Ruby', description: 'A beginner\'s guide to Ruby programming', duration_in_weeks: 4, difficulty_level: 'Beginner', published: true).id }
              let(:learning_path) { { name: 'Learn Rails', description: 'A beginner\'s guide to Ruby on Rails programming', duration_in_weeks: 8, difficulty_level: 'Intermediate', published: true } }
              run_test!
            end

            response '422', 'invalid request' do
              let(:id) { LearningPath.create(name: 'Learn Ruby', description: 'A beginner\'s guide to Ruby programming', duration_in_weeks: 4, difficulty_level: 'Beginner', published: true).id }
              let(:learning_path) { { name: '', description: '', duration_in_weeks: '', difficulty_level: '', published: '' } }
              run_test!
            end

            response '404', 'learning path not found' do
              let(:id) { 'invalid' }
              let(:learning_path) { { name: 'Learn Rails', description: 'A beginner\'s guide to Ruby on Rails programming', duration_in_weeks: 8, difficulty_level: 'Intermediate', published: true } }
              run_test!
            end
          end
        end
    end

end
