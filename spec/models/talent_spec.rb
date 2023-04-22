require 'rails_helper'
RSpec.describe Talent, type: :model do
  describe "validations" do
    subject { build(:talent) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:level) }
    it { should validate_inclusion_of(:category).in?([1, 2, 3, 4, 5]) }
    it { should validate_inclusion_of(:level).in?([1, 2, 3, 4]) }

    it { should validate_uniqueness_of(:name) }

    it "validates the presence of name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "validates the presence of category" do
      subject.category = nil
      expect(subject).to_not be_valid
    end

    it "validates the presence of level" do
      subject.level = nil
      expect(subject).to_not be_valid
    end
  end

  describe "associations" do
    it { should have_many(:course_talents).dependent(:destroy) }
    it { should have_many(:courses).through(:course_talents) }
    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:learning_paths).through(:enrollments) }
  end

  describe "enums" do
    it { should define_enum_for(:category).in?([1,2,3,4,5]) }
    it { should define_enum_for(:level).in?([1,2,3,4]) }
  end

  describe "callbacks" do
    describe "before_destroy" do
      let!(:talent) { FactoryBot.create(:talent) }

      it "should destroy if associated with courses" do
        course = FactoryBot.create(:course)
        course.talents << talent
        expect { talent.destroy }.to change { Talent.count }
      end

      it "should destroy if not associated with courses" do
        expect { talent.destroy }.to change { Talent.count }.by(-1)
      end
    end
  end

  describe "scopes" do
    describe ".by_category" do
      let!(:design_talent) { FactoryBot.create(:talent, category: "design") }
      let!(:marketing_talent) { FactoryBot.create(:talent, category: "marketing") }

      it "returns talents with matching category" do
        expect(Talent.by_category("design")).to include(design_talent)
      end

      it "does not return talents with non-matching category" do
        expect(Talent.by_category("development")).to_not include(design_talent)
      end
    end

    describe ".by_level" do
      let!(:beginner_talent) { FactoryBot.create(:talent, level: "beginner") }
      let!(:intermediate_talent) { FactoryBot.create(:talent, level: "intermediate") }

      it "returns talents with matching level" do
        expect(Talent.by_level("beginner")).to include(beginner_talent)
      end

      it "does not return talents with non-matching level" do
        expect(Talent.by_level("advanced")).to_not include(beginner_talent)
      end
    end
  end
end

