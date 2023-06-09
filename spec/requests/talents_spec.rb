require 'rails_helper'
require 'swagger_helper'

RSpec.describe TalentsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index, format: :json
      expect(response).to be_successful
    end

    it 'returns all talents' do
      Talent.destroy_all
      talent1 = FactoryBot.create(:talent)
      talent2 = FactoryBot.create(:talent)
      get :index, format: :json
      expect(assigns(:talents)).to match_array([talent1, talent2])
    end
  end

  describe 'GET #show' do
    let(:talent) { FactoryBot.create(:talent) }

    it 'returns a success response' do
      get :show, params: { id: talent.to_param }, format: :json
      expect(response).to be_successful
    end

    it 'returns the correct talent' do
      get :show, params: { id: talent.to_param }, format: :json
      expect(assigns(:talent)).to eq(talent)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new talent' do
        expect {
          post :create, params: { talent: FactoryBot.attributes_for(:talent) }, format: :json
        }.to change(Talent, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { talent: FactoryBot.attributes_for(:talent) }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        post :create, params: { talent: FactoryBot.attributes_for(:talent, name: nil) }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let(:talent) { FactoryBot.create(:talent) }

    context 'with valid params' do
      it 'updates the talent' do
        new_name = 'New Talent Name'
        patch :update, params: { id: talent.to_param, talent: { name: new_name } }, format: :json
        talent.reload
        expect(talent.name).to eq(new_name)
      end

      it 'returns the updated talent' do
        patch :update, params: { id: talent.to_param, talent: { name: 'New Talent Name' } }, format: :json
        expect(assigns(:talent)).to eq(talent)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        patch :update, params: { id: talent.to_param, talent: { name: nil } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:talent) { FactoryBot.create(:talent) }

    it 'destroys the talent' do
      expect {
        delete :destroy, params: { id: talent.to_param }, format: :json
      }.to change(Talent, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
