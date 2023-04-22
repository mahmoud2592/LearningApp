require 'rails_helper'
RSpec.describe Enrollment, type: :model do

  let(:talent) { FactoryBot.create(:talent) }
  let(:learning_path) { FactoryBot.create(:learning_path) }

  describe 'validations' do
    it { should validate_presence_of(:enrollment_date) }
    it { should validate_uniqueness_of(:talent_id).scoped_to(:learning_path_id) }
  end

  describe 'associations' do
    it { should belong_to(:talent) }
    it { should belong_to(:learning_path) }
  end

  describe 'scopes' do
    let!(:enrollment1) { FactoryBot.create(:enrollment, talent: talent, learning_path: learning_path, enrollment_date: Date.today) }
    let!(:enrollment2) { FactoryBot.create(:enrollment, talent: talent, enrollment_date: Date.today - 1) }

    describe '.by_talent' do
      it 'returns enrollments for the given talent' do
        expect(Enrollment.by_talent(talent)).to contain_exactly(enrollment1, enrollment2)
      end
    end

    describe '.by_learning_path' do
      it 'returns enrollments for the given learning path' do
        expect(Enrollment.by_learning_path(learning_path)).to contain_exactly(enrollment1)
      end
    end

    describe '.by_date' do
      it 'returns enrollments for the given date' do
        expect(Enrollment.by_date(Date.today)).to contain_exactly(enrollment1)
      end
    end
  end
end
