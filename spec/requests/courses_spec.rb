require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe 'GET #index' do
    before do
      FactoryBot.create_list(:course, 3)
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a list of courses' do
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET #show' do
    let!(:course) { FactoryBot.create(:course) }

    before do
      get :show, params: { id: course.id }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct course' do
      expect(JSON.parse(response.body)['id']).to eq(course.id)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:author) { FactoryBot.create(:author) }
      let(:learning_path) { FactoryBot.create(:learning_path) }
      let(:course_attributes) { FactoryBot.attributes_for(:course, difficulty: :beginner, author_id: author.id, learning_path_id: learning_path.id) }

      it 'creates a new course' do
        expect {
          post :create, params: { course: course_attributes }
        }.to change(Course, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { name: nil } }

      it 'does not create a new course' do
        expect {
          post :create, params: { course: invalid_attributes }
        }.to_not change(Course, :count)
      end

      it 'returns http unprocessable entity' do
        post :create, params: { course: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    let!(:course) { FactoryBot.create(:course) }

    context 'with valid attributes' do
      let(:new_attributes) { { name: 'New Name' } }

      before do
        patch :update, params: { id: course.id, course: new_attributes }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the course' do
        expect(course.reload.name).to eq('New Name')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { name: nil } }

      before do
        patch :update, params: { id: course.id, course: invalid_attributes }
      end

      it 'returns http unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the course' do
        expect(course.reload.name).to_not be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:course) { FactoryBot.create(:course) }

    it 'destroys the course' do
      expect {
        delete :destroy, params: { id: course.id }
      }.to change(Course, :count).by(-1)
    end

    it 'returns http no content' do
      delete :destroy, params: { id: course.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
