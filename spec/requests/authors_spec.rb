
require 'rails_helper'
require 'swagger_helper'

RSpec.describe AuthorsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    # it "returns all authors" do
    #   Author.destroy_all
    #   FactoryBot.create_list(:author, 5)
    #   get :index
    #   expect(JSON.parse(response.body).size).to eq(5)
    # end
  end

  describe "GET #show" do
    let(:author) { FactoryBot.create(:author) }

    it "returns http success" do
      get :show, params: { id: author.id }
      expect(response).to have_http_status(:success)
    end

    it "returns the correct author" do
      get :show, params: { id: author.id }
      expect(JSON.parse(response.body)["id"]).to eq(author.id)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) { FactoryBot.attributes_for(:author) }

      it "creates a new author" do
        expect {
          post :create, params: { author: valid_attributes }
        }.to change(Author, :count).by(1)
      end

      it "returns http success" do
        post :create, params: { author: valid_attributes }
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { FactoryBot.attributes_for(:author, name: nil) }

      it "does not create a new author" do
        expect {
          post :create, params: { author: invalid_attributes }
        }.not_to change(Author, :count)
      end

      it "returns http unprocessable entity" do
        post :create, params: { author: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    let(:author) { FactoryBot.create(:author) }

    context "with valid params" do
      let(:new_attributes) { FactoryBot.attributes_for(:author, name: "New Name") }

      it "updates the requested author" do
        patch :update, params: { id: author.id, author: new_attributes }
        author.reload
        expect(author.name).to eq("New Name")
      end

      it "returns http success" do
        patch :update, params: { id: author.id, author: new_attributes }
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { FactoryBot.attributes_for(:author, name: nil) }

      it "does not update the requested author" do
        old_name = author.name
        patch :update, params: { id: author.id, author: invalid_attributes }
        author.reload
        expect(author.name).to eq(old_name)
      end

      it "returns http unprocessable entity" do
        patch :update, params: { id: author.id, author: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:author) { FactoryBot.create(:author) }

    it "destroys the requested author" do
      expect {
        delete :destroy, params: { id: author.id }
      }.to change(Author, :count).by(0)
    end
  end
end
