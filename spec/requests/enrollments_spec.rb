require 'rails_helper'
require 'swagger_helper'

RSpec.describe EnrollmentsController, type: :controller do
  # before do
  #   FactoryBot.create_list(:enrollment, 20)
  # end

  describe "GET #index" do
    let(:enrollment) { FactoryBot.create(:enrollment) }

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns a list of enrollments" do
      enrollment
      get :index
      expect(assigns(:enrollments)).to eq([enrollment])
    end

    it "filters enrollments by talent_id" do
      enrollment
      get :index, params: { talent_id: enrollment.talent_id }
      expect(assigns(:enrollments)).to eq([enrollment])
    end

    it "filters enrollments by learning_path_id" do
      enrollment
      get :index, params: { learning_path_id: enrollment.learning_path_id }
      expect(assigns(:enrollments)).to eq([enrollment])
    end

    it "filters enrollments by date" do
      enrollment
      get :index, params: { date: enrollment.enrollment_date }
      expect(assigns(:enrollments)).to eq([enrollment])
    end
  end

  describe "GET #show" do
    let(:enrollment) { FactoryBot.create(:enrollment) }

    it "returns http success" do
      get :show, params: { id: enrollment.id }
      expect(response).to have_http_status(:success)
    end

    it "returns the enrollment with the specified id" do
      get :show, params: { id: enrollment.id }
      expect(assigns(:enrollment)).to eq(enrollment)
    end
  end

  describe "POST #create" do
    let(:talent) { FactoryBot.create(:talent) }
    let(:learning_path) { FactoryBot.create(:learning_path) }
    let(:valid_attributes) { { talent_id: talent.id, learning_path_id: learning_path.id, enrollment_date: Date.today } }
    let(:invalid_attributes) { { talent_id: talent.id, learning_path_id: nil, enrollment_date: Date.today } }

    context "with valid attributes" do
      it "creates a new enrollment" do
        expect {
          post :create, params: { enrollment: valid_attributes }
        }.to change(Enrollment, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid attributes" do
      it "returns a 422 status code" do
        post :create, params: { enrollment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    let(:enrollment) { FactoryBot.create(:enrollment) }
    let(:new_learning_path) { FactoryBot.create(:learning_path) }
    let(:valid_attributes) { { learning_path_id: new_learning_path.id } }
    let(:invalid_attributes) { { learning_path_id: nil } }

    context "with valid attributes" do
      it "updates the enrollment" do
        patch :update, params: { id: enrollment.id, enrollment: valid_attributes }
        expect(assigns(:enrollment).learning_path).to eq(new_learning_path)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid attributes" do
      it "returns a 422 status code" do
        patch :update, params: { id: enrollment.id, enrollment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
