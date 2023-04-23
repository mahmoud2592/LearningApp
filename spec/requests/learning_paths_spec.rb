require 'rails_helper'
require 'swagger_helper'

RSpec.describe LearningPathsController, type: :controller do
  before do
    LearningPath.destroy_all
  end
  describe 'GET #index' do
    let!(:learning_path_1) { FactoryBot.create(:learning_path, difficulty_level: 'expert') }
    let!(:learning_path_2) { FactoryBot.create(:learning_path, difficulty_level: 'expert') }
    let!(:learning_path_3) { FactoryBot.create(:learning_path, difficulty_level: 'advanced') }
    let!(:learning_path_4) { FactoryBot.create(:learning_path, name: 'Ruby on Rails', difficulty_level: 'expert') }

    it 'returns a success response' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns all learning paths' do
      get :index, format: :json
      expect(assigns(:learning_paths)).to match_array(LearningPath.all)
    end

    it 'filters by difficulty level' do
      get :index, params: { difficulty_level: 'advanced' }, format: :json
      expect(assigns(:learning_paths)).to match_array([learning_path_3])
    end

    it 'filters by search query' do
      get :index, params: { q: 'Ruby' }, format: :json
      expect(assigns(:learning_paths)).to match_array([learning_path_4])
    end

    it 'sorts by views count' do
      learning_path_1.update(views_count: 10)
      learning_path_2.update(views_count: 5)
      learning_path_3.update(views_count: 20)
      learning_path_4.update(views_count: 15)

      get :index, params: { sort: 'views' }, format: :json
      expect(assigns(:learning_paths)).to eq([learning_path_3, learning_path_4, learning_path_1, learning_path_2])
    end
  end

  describe 'GET #show' do
    let!(:learning_path) { FactoryBot.create(:learning_path) }

    it 'returns a success response' do
      get :show, params: { id: learning_path.id }, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct learning path' do
      get :show, params: { id: learning_path.id }, format: :json
      expect(assigns(:learning_path)).to eq(learning_path)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) { FactoryBot.attributes_for(:learning_path) }

      it 'creates a new learning path' do
        expect {
          post :create, params: { learning_path: valid_attributes }, format: :json
        }.to change(LearningPath, :count).by(1)
      end

      it 'returns a success response' do
        post :create, params: { learning_path: valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { FactoryBot.attributes_for(:learning_path, name: '') }

      it 'does not create a new learning path' do
        expect {
          post :create, params: { learning_path: invalid_attributes }, format: :json
        }.to_not change(LearningPath, :count)
      end

      it 'returns an unprocessable_entity response' do
        post :create, params: { learning_path: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
