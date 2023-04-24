require 'swagger_helper'

describe 'CourseTalents API' do
  path '/course_talents' do
    get 'Retrieves all course talents' do
      tags 'CourseTalents'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'returns all course talents' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :integer },
                   course_id: { type: :integer },
                   talent_id: { type: :integer },
                   completed: { type: :boolean },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 }
               }
        let(:course_talents) { create_list(:course_talent, 2) }
        run_test!
      end
    end

    post 'Creates a course talent' do
      tags 'CourseTalents'
      consumes 'application/json'
      parameter name: :course_talent, in: :body, schema: {
        type: :object,
        properties: {
          course_id: { type: :integer },
          talent_id: { type: :integer },
          completed: { type: :boolean }
        },
        required: %w[course_id talent_id]
      }

      response '201', 'course talent created' do
        let(:course_talent) { build(:course_talent) }
        let(:created_course_talent) do
          {
            course_id: course_talent.course_id,
            talent_id: course_talent.talent_id
          }
        end

        run_test! do
          expect(JSON.parse(response.body)).to include(created_course_talent)
        end
      end

      response '422', 'invalid request' do
        let(:course_talent) { build(:course_talent, course_id: nil) }
        let(:invalid_course_talent) do
          {
            error: {
              course_id: ["can't be blank"]
            }
          }
        end

        run_test! do
          expect(JSON.parse(response.body)).to eq(invalid_course_talent)
        end
      end
    end
  end

    path '/course_talents/{id}' do
      get 'Retrieves a course talent' do
        tags 'CourseTalents'
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
        put 'Updates a course talent' do
            tags 'CourseTalents'
            consumes 'application/json'
            parameter name: :id, in: :path, type: :integer
            parameter name: :course_talent, in: :body, schema: {
              type: :object,
              properties: {
                course_id: { type: :integer },
                talent_id: { type: :integer },
                completed: { type: :boolean }
              },
              required: %w[course_id talent_id]
            }

            response '200', 'course talent updated' do
              let(:course_talent) { create(:course_talent) }
              let(:id) { course_talent.id }
              let(:updated_course_talent) do
                {
                  course_id: course_talent.course_id,
                  talent_id: course_talent.talent_id,
                  completed: course_talent.completed
                }
              end

              run_test! do
                expect(JSON.parse(response.body)).to include(updated_course_talent)
              end
            end

            response '422', 'invalid request' do
              let(:course_talent) { create(:course_talent) }
              let(:id) { course_talent.id }
              let(:invalid_course_talent) do
                {
                  error: {
                    course_id: ["can't be blank"]
                  }
                }
              end

              run_test! do
                expect(JSON.parse(response.body)).to eq(invalid_course_talent)
              end
            end
          end

          delete 'Deletes a course talent' do
            tags 'CourseTalents'
            produces 'application/json'
            parameter name: :id, in: :path, type: :integer

            response '204', 'course talent deleted' do
              let(:course_talent) { create(:course_talent) }
              let(:id) { course_talent.id }

              run_test! do
                expect(response.status).to eq(204)
              end
            end

            response '404', 'course talent not found' do
              let(:id) { 'invalid' }
              run_test!
            end
          end

    end
end
