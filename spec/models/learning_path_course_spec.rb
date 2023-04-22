require 'rails_helper'
RSpec.describe LearningPathCourse, type: :model do
  let(:learning_path) { FactoryBot.create(:learning_path) }
  let(:course) { FactoryBot.create(:course) }
  let(:talent) { FactoryBot.create(:talent) }
  let(:lpc) { FactoryBot.create(:learning_path_course, learning_path: learning_path, course: course) }

  describe "validations" do
    it { should validate_presence_of(:learning_path) }
    it { should validate_presence_of(:course) }
    it { should validate_uniqueness_of(:course_id).scoped_to(:learning_path_id) }
  end

  describe "associations" do
    it { should belong_to(:learning_path) }
    it { should belong_to(:course) }
  end

  describe "scopes" do
    describe ".by_learning_path" do
      it "returns all learning path courses for the given learning path id" do
        lpc
        expect(LearningPathCourse.by_learning_path(learning_path.id)).to include(lpc)
      end
    end
  end

  describe ".by_course" do
    it "returns all learning path courses for the given course id" do
      lpc
      expect(LearningPathCourse.by_course(course.id)).to include(lpc)
    end
  end

  describe ".required" do
    it "returns all required learning path courses" do
      required_lpc = FactoryBot.create(:learning_path_course, learning_path: learning_path, course: course, required: true)
      FactoryBot.create(:learning_path_course, learning_path: learning_path, course: FactoryBot.create(:course), required: false)

      expect(LearningPathCourse.required).to include(required_lpc)
    end
  end

  describe ".completed" do
    it "returns all completed learning path courses" do
      completed_lpc = FactoryBot.create(:learning_path_course, learning_path: learning_path, course: course, completed_at: Time.current)
      FactoryBot.create(:learning_path_course, learning_path: learning_path, course: FactoryBot.create(:course), completed_at: nil)

      expect(LearningPathCourse.completed).to include(completed_lpc)
    end
  end

  describe ".with_rating" do
    it "returns all learning path courses with a rating" do
      rated_lpc = FactoryBot.create(:learning_path_course, learning_path: learning_path, course: course, rating: 4.5)
      FactoryBot.create(:learning_path_course, learning_path: learning_path, course: FactoryBot.create(:course), rating: nil)

      expect(LearningPathCourse.with_rating).to include(rated_lpc)
    end
  end
end
