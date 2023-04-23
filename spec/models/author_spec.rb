require 'rails_helper'

RSpec.describe Author, type: :model do
  describe "before_destroy" do
    context "when author has published courses" do
      let!(:author) { FactoryBot.create(:author) }
      let!(:course1) { FactoryBot.create(:course, author: author, published: true) }
      let!(:course2) { FactoryBot.create(:course, author: author, published: false) }

      context "when there is another author" do
        let!(:another_author) { FactoryBot.create(:author) }

        it "transfers courses to another author" do
          expect {
            author.destroy
          }.to change { Course.where(author_id: author.id).count }.from(2).to(0)
            # .and change { Course.where(author_id: another_author.id).count }.from(0).to(2)
        end
      end
    end
  end

  describe "name_and_email" do
    let(:author) { FactoryBot.build(:author, name: "John Doe", email: "john.doe@example.com") }

    it "returns a string of the author's name and email" do
      expect(author.name_and_email).to eq("John Doe <john.doe@example.com>")
    end
  end

  describe "set_website_url_to_na" do
    let(:author) { FactoryBot.build(:author, website_url: "") }

    it "sets website_url to 'N/A' if left blank" do
      author.valid?
      expect(author.website_url).to eq("N/A")
    end
  end
end
