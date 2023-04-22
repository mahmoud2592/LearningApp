require 'rails_helper'
RSpec.describe CourseTalentsController, type: :controller do
  let(:course) { FactoryBot.create(:course) }
  let(:talent) { FactoryBot.create(:talent) }
  let(:valid_attributes) { { course_id: course.id, talent_id: talent.id } }
  let(:invalid_attributes) { { course_id: nil, talent_id: nil } }
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      course_talent = FactoryBot.create(:course_talent, valid_attributes)
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      course_talent = FactoryBot.create(:course_talent, valid_attributes)
      get :show, params: { id: course_talent.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new CourseTalent" do
        expect {
          post :create, params: { course_talent: valid_attributes }
        }.to change(CourseTalent, :count).by(1)
      end

      it "renders a JSON response with the new course_talent" do
        post :create, params: { course_talent: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.location).to eq(course_talent_url(CourseTalent.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new course_talent" do
        post :create, params: { course_talent: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:talent1) { FactoryBot.create(:talent) }
      let(:new_attributes) { { talent_id: talent1.id } }

      it "renders a JSON response with the updated course_talent" do
        course_talent = FactoryBot.create(:course_talent, valid_attributes)
        patch :update, params: { id: course_talent.to_param, course_talent: valid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the course_talent" do
        course_talent = FactoryBot.create(:course_talent, valid_attributes)
        patch :update, params: { id: course_talent.to_param, course_talent: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
