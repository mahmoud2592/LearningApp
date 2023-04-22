require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "validations" do
    subject { build(:course) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:duration).only_integer.is_greater_than(0) }
    it { should validate_inclusion_of(:difficulty).in?([1, 2, 3, 4]) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_uniqueness_of(:slug) }
  end

  describe "associations" do
    it { should belong_to(:author) }
    it { should belong_to(:learning_path) }
    it { should have_many(:learning_path_courses).dependent(:destroy) }
    it { should have_many(:course_talents).dependent(:destroy) }
    it { should have_many(:talents).through(:course_talents) }
  end

  describe "scopes" do
    describe "published" do
      let!(:published_course) { FactoryBot.create(:course, published: true) }
      let!(:unpublished_course) { FactoryBot.create(:course, published: false) }

      it "returns only published courses" do
        expect(Course.published).to include(published_course)
        expect(Course.published).not_to include(unpublished_course)
      end
    end

    describe "unpublished" do
      let!(:published_course) { FactoryBot.create(:course, published: true) }
      let!(:unpublished_course) { FactoryBot.create(:course, published: false) }

      it "returns only unpublished courses" do
        expect(Course.unpublished).to include(unpublished_course)
        expect(Course.unpublished).not_to include(published_course)
      end
    end

    describe "by_difficulty" do
      let!(:beginner_course) { FactoryBot.create(:course, difficulty: :beginner) }
      let!(:advanced_course) { FactoryBot.create(:course, difficulty: :advanced) }

      it "returns courses by difficulty level" do
        expect(Course.by_difficulty(:beginner)).to include(beginner_course)
        expect(Course.by_difficulty(:beginner)).not_to include(advanced_course)
        expect(Course.by_difficulty(:advanced)).to include(advanced_course)
        expect(Course.by_difficulty(:advanced)).not_to include(beginner_course)
      end
    end

    describe "by_learning_path" do
      let!(:learning_path) { FactoryBot.create(:learning_path) }
      let!(:course1) { FactoryBot.create(:course, learning_path: learning_path) }
      let!(:course2) { FactoryBot.create(:course) }

      it "returns courses by learning path" do
        expect(Course.by_learning_path(learning_path.id)).to include(course1)
        expect(Course.by_learning_path(learning_path.id)).not_to include(course2)
      end
    end

    describe "by_author" do
      let!(:author) { FactoryBot.create(:author) }
      let!(:course1) { FactoryBot.create(:course, author: author) }
      let!(:course2) { FactoryBot.create(:course) }

      it "returns courses by author" do
        expect(Course.by_author(author.id)).to include(course1)
        expect(Course.by_author(author.id)).not_to include(course2)
      end
    end
  end
end
