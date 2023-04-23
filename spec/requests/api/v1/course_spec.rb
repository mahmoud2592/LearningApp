RSpec.describe CoursesController, type: :request do
  describe 'Courses API' do
    path '/courses' do
      get 'Retrieves a list of courses' do
        tags 'Courses'
        produces 'application/json'
        parameter name: :difficulty, in: :query, type: :string, description: 'Filter by difficulty'
        parameter name: :published, in: :query, type: :boolean, description: 'Filter by published status'
        parameter name: :q, in: :query, type: :string, description: 'Search term'
        parameter name: :sort, in: :query, type: :string, description: 'Sort by views count'
  
        response '200', 'courses found' do
          schema type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                description: { type: :string },
                video_url: { type: :string },
                duration: { type: :integer },
                difficulty: { type: :string },
                price: { type: :number },
                published: { type: :boolean },
                learning_path_id: { type: :integer },
                author_id: { type: :integer },
                created_at: { type: :string },
                updated_at: { type: :string }
              },
              required: [ 'id', 'name', 'description', 'video_url', 'duration', 'difficulty', 'price', 'published', 'learning_path_id', 'author_id', 'created_at', 'updated_at' ]
            }
  
          let(:course1) { create(:course) }
          let(:course2) { create(:course) }
          let(:difficulty) { course1.difficulty }
          let(:published) { course2.published }
          let(:q) { 'ruby' }
          let(:sort) { 'views' }
  
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data.length).to eq(2)
            expect(data[0]['id']).to eq(course1.id)
            expect(data[1]['id']).to eq(course2.id)
          end
        end
  
        response '422', 'invalid request' do
          let(:difficulty) { 'invalid' }
  
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['error']).to eq('Invalid difficulty level')
          end
        end
      end
    end

    path '/courses/{id}' do
      get 'Retrieves a course' do
        tags 'Courses'
        produces 'application/json'
        parameter name: :id, in: :path, type: :string

        response '200', 'course found' do
          schema '$ref' => '#/components/schemas/course'

          let(:id) { create(:course).id }
          run_test!
        end

        response '404', 'course not found' do
          let(:id) { 'invalid' }
          run_test!
        end

        response '401', 'unauthorized' do
          let(:Authorization) { 'Bearer invalid_token' }
          let(:id) { create(:course).id }
          run_test!
        end
      end
    end

    path '/courses' do
      post 'Creates a course' do
        tags 'Courses'
        consumes 'application/json'
        parameter name: :course, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            description: { type: :string },
            video_url: { type: :string },
            duration: { type: :integer },
            difficulty: { type: :string },
            price: { type: :number },
            published: { type: :boolean },
            learning_path_id: { type: :integer },
            author_id: { type: :integer }
          },
          required: ['name', 'description', 'video_url', 'duration', 'difficulty', 'price', 'published', 'learning_path_id', 'author_id']
        }

        response '201', 'course created' do
          schema '$ref' => '#/components/schemas/course'

          let(:course) { FactoryBot.attributes_for(:course) }
          run_test!
        end

        response '422', 'invalid request' do
          schema '$ref' => '#/components/schemas/validation_error'

          let(:course) { FactoryBot.attributes_for(:course, name: '') }
          run_test!
        end

        response '401', 'unauthorized' do
          let(:Authorization) { 'Bearer invalid_token' }
          let(:course) { FactoryBot.attributes_for(:course) }
          run_test!
        end
      end
    end
  end

  path '/courses/{id}' do
    put 'Updates a course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :course_params, in: :body, schema: {
        type: :object,
        properties: {
          course: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          }
        }
      }

      response '200', 'course updated' do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { create(:user).create_access_token.token }
        let(:course_params) { course_params }
        run_test! do
          expect(json['name']).to eq new_name
        end
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{token}" }
        let(:token) { create(:user).create_access_token.token }
        let(:course_params) do
          {
            course: {
              name: nil
            }
          }
        end
        run_test!
      end
    end
  end

  path "/courses/{id}" do
    delete "Deletes a course" do
      tags "Courses"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :string, description: "ID of the course"

      response "204", "No Content" do
        let(:id) { course.id }

        run_test!
      end

      response "404", "Not Found" do
        let(:id) { "invalid" }

        run_test!
      end
    end
  end
end
