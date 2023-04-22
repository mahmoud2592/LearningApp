require 'rails_helper'

RSpec.describe CourseTalent, type: :model do
  let(:course) { FactoryBot.create(:course) }
  let(:talent) { FactoryBot.create(:talent) }
  let(:course_talent) { FactoryBot.create(:course_talent, course: course, talent: talent) }

  describe 'associations' do
    it { should belong_to(:course) }
    it { should belong_to(:talent) }
  end

  describe 'scopes' do
    describe '.by_course' do
      it 'returns course talents for a given course' do
        ct1 = FactoryBot.create(:course_talent, course: course)
        ct2 = FactoryBot.create(:course_talent, course: course)
        expect(CourseTalent.by_course(course.id)).to match_array([ct1, ct2])
      end
    end

    describe '.by_talent' do
      it 'returns course talents for a given talent' do
        ct1 = FactoryBot.create(:course_talent, talent: talent)
        ct2 = FactoryBot.create(:course_talent, talent: talent)
        expect(CourseTalent.by_talent(talent.id)).to match_array([ct1, ct2])
      end
    end

    describe '.required' do
      it 'returns course talents that are required for their course' do
        required_course = FactoryBot.create(:course)
        FactoryBot.create(:learning_path_course, required: true, course: required_course)
        required_ct = FactoryBot.create(:course_talent, course: required_course)

        non_required_course = FactoryBot.create(:course)
        FactoryBot.create(:learning_path_course, required: false, course: non_required_course)
        FactoryBot.create(:course_talent, course: non_required_course)

        expect(CourseTalent.required).to eq([required_ct])
      end

    end
  end

  describe '#required?' do
    it 'returns true if the course talent is required' do
      FactoryBot.create(:learning_path_course, required: true, course: course)
      required_ct = FactoryBot.create(:course_talent, course: course)
      expect(required_ct.required?).to be_truthy
    end

    it 'returns false if the course talent is not required' do
      optional_ct = FactoryBot.create(:course_talent, course: course)
      expect(optional_ct.required?).to be_falsy
    end
  end

  describe '#duration' do
    it 'calculates the correct duration for the course talent' do
      course.update(duration: 10)
      talent.update(level: 3)
      expect(course_talent.duration).to eq(30)
    end
  end

  describe 'callbacks' do
    describe 'after_save' do
      it 'updates the course difficulty' do
        course.update(difficulty: 1)
        FactoryBot.create(:course_talent, course: course, talent: FactoryBot.create(:talent, level: 2))
        expect(Course.difficulties[course.reload.difficulty]).to eq(2)
      end
    end

    describe 'after_destroy' do
      it 'updates the course difficulty' do
        ct1 = FactoryBot.create(:course_talent, course: course, talent: FactoryBot.create(:talent, level: 2))
        ct2 = FactoryBot.create(:course_talent, course: course, talent: FactoryBot.create(:talent, level: 3))
        ct1.destroy
        expect(Course.difficulties[course.reload.difficulty]).to eq(2)
        ct2.destroy
        expect(Course.difficulties[course.reload.difficulty]).to eq(1)
      end
    end
  end
end
