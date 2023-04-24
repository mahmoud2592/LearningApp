require 'swagger_helper'

RSpec.describe EnrollmentsController, type: :request do
  path '/enrollments' do
    post 'Creates an enrollment' do
      tags 'Enrollments'
      consumes 'application/json'
      parameter name: :enrollment, in: :body, schema: {
        type: :object,
        properties: {
          talent_id: { type: :integer },
          learning_path_id: { type: :integer },
          enrollment_date: { type: :string },
          completed: {type: :boolean},
          completed_at: {type: :date}
        },
        required: [ 'talent_id', 'learning_path_id', 'enrollment_date' ]
      }

      response '201', 'enrollment created' do
        let(:enrollment) { { talent_id: Talent.first.id, learning_path_id: LearningPath.first.id, enrollment_date: '2023-04-24' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:enrollment) { { talent_id: nil, learning_path_id: nil, enrollment_date: nil } }
        run_test!
      end
    end

    get 'Retrieves enrollments' do
      tags 'Enrollments'
      produces 'application/json'

      parameter name: :talent_id, in: :query, type: :integer
      parameter name: :learning_path_id, in: :query, type: :integer
      parameter name: :date, in: :query, type: :string

      response '200', 'enrollments found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              talent_id: { type: :integer },
              learning_path_id: { type: :integer },
              enrollment_date: { type: :string },
              completed: {type: :boolean},
                  completed_at: {type: :date},
            },
            required: [ 'id', 'talent_id', 'learning_path_id', 'enrollment_date' ]
          }

        run_test!
      end

      response '404', 'enrollments not found' do
        let(:talent_id) { 0 }
        let(:learning_path_id) { 0 }
        let(:date) { '2023-04-24' }
        run_test!
      end
    end
  end
    describe 'GET /enrollments' do
      let!(:enrollments) { create_list(:enrollment, 3) }

      context 'when filtering by talent' do
        let!(:talent) { create(:talent) }
        let!(:enrollment) { create(:enrollment, talent: talent) }

        before do
          get '/enrollments', params: { talent_id: talent.id }
        end

        it 'returns only enrollments of the specified talent' do
          expect(json['data'].size).to eq(1)
          expect(json['data'][0]['id']).to eq(enrollment.id.to_s)
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when filtering by learning path' do
        let!(:learning_path) { create(:learning_path) }
        let!(:enrollment) { create(:enrollment, learning_path: learning_path) }

        before do
          get '/enrollments', params: { learning_path_id: learning_path.id }
        end

        it 'returns only enrollments of the specified learning path' do
          expect(json['data'].size).to eq(1)
          expect(json['data'][0]['id']).to eq(enrollment.id.to_s)
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when filtering by date' do
        let!(:enrollment1) { create(:enrollment, enrollment_date: Date.today) }
        let!(:enrollment2) { create(:enrollment, enrollment_date: Date.today - 1.day) }

        before do
          get '/enrollments', params: { date: Date.today.to_s }
        end

        it 'returns only enrollments with the specified date' do
          expect(json['data'].size).to eq(1)
          expect(json['data'][0]['id']).to eq(enrollment1.id.to_s)
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when no filters are applied' do
        before do
          get '/enrollments'
        end

        it 'returns all enrollments' do
          expect(json['data'].size).to eq(3)
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'GET /enrollments/:id' do
        let!(:enrollment) { create(:enrollment) }

        path '/enrollments/{id}' do
          get 'Retrieves an enrollment' do
            tags 'Enrollments'
            produces 'application/json'
            parameter name: :id, in: :path, type: :string

            response '200', 'enrollment found' do
              schema type: :object,
                properties: {
                  id: { type: :integer },
                  talent: { '$ref' => '#/components/schemas/talent' },
                  learning_path: { '$ref' => '#/components/schemas/learning_path' },
                  enrollment_date: { type: :string },
                  completed: {type: :boolean},
                  completed_at: {type: :date},
                },
                required: [ 'id', 'talent', 'learning_path', 'enrollment_date' ]

              let(:id) { enrollment.id }
              run_test!
            end

            response '404', 'enrollment not found' do
              let(:id) { 'invalid' }
              run_test!
            end
          end
        end
      end

      describe 'DELETE /enrollments/:id' do
        let!(:enrollment) { create(:enrollment) }

        path '/enrollments/{id}' do
          delete 'Deletes an enrollment' do
            tags 'Enrollments'
            produces 'application/json'
            parameter name: :id, in: :path, type: :string

            response '204', 'enrollment deleted' do
              let(:id) { enrollment.id }
              run_test!
            end

            response '404', 'enrollment not found' do
              let(:id) { 'invalid' }
              run_test!
            end
          end
        end
      end

      describe 'Enrollments API' do

        path '/enrollments' do

          post 'Creates an enrollment' do
            tags 'Enrollments'
            consumes 'application/json'
            parameter name: :enrollment, in: :body, schema: {
              type: :object,
              properties: {
                talent_id: { type: :integer },
                learning_path_id: { type: :integer },
              },
              required: [ 'talent_id', 'learning_path_id', 'enrollment_date' ]
            }

            response '201', 'enrollment created' do
              let(:enrollment) { { talent_id: 1, learning_path_id: 1, enrollment_date: '2023-04-23', completed: true } }
              run_test!
            end

            response '422', 'invalid request' do
              let(:enrollment) { { talent_id: nil, learning_path_id: nil, enrollment_date: nil, completed: nil } }
              run_test!
            end
          end
        end

        path '/enrollments/{id}' do

          patch 'Updates an enrollment' do
            tags 'Enrollments'
            consumes 'application/json'
            parameter name: :id, in: :path, type: :integer
            parameter name: :enrollment, in: :body, schema: {
              type: :object,
              properties: {
                talent_id: { type: :integer },
                learning_path_id: { type: :integer },
              }
            }

            response '200', 'enrollment updated' do
              let(:id) { Enrollment.create(talent_id: 1, learning_path_id: 1, enrollment_date: '2023-04-23').id }
              let(:enrollment) { { talent_id: 2, learning_path_id: 2, enrollment_date: '2023-04-24', completed: true } }
              run_test!
            end

            response '422', 'invalid request' do
              let(:id) { Enrollment.create(talent_id: 1, learning_path_id: 1, enrollment_date: '2023-04-23').id }
              let(:enrollment) { { talent_id: nil, learning_path_id: nil, enrollment_date: nil, completed: nil } }
              run_test!
            end
          end
        end
      end

  end
