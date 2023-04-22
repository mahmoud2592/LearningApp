require 'rails_helper'
RSpec.describe LearningPath, type: :model do
  let(:learning_path) { FactoryBot.create(:learning_path, duration_in_weeks: 7) }
  let(:courses) { FactoryBot.create_list(:course, 3, learning_path: learning_path) }
  let(:course1) { FactoryBot.create(:course, duration: 120, rating: 4.5) }
  let(:course2) { FactoryBot.create(:course, duration: 90, rating: 3.8) }
  let(:course3) { FactoryBot.create(:course, duration: 180, rating: 4.0) }

  describe "validations" do
    it "is valid with all required attributes" do
      expect(learning_path).to be_valid
    end
    it "is invalid without a name" do
      learning_path.name = nil
      expect(learning_path).to be_invalid
    end
    it "is invalid with a non-positive duration_in_weeks" do
      learning_path.duration_in_weeks = -1
      expect(learning_path).to be_invalid
    end

    it "is invalid without a description" do
      learning_path.description = nil
      expect(learning_path).to be_invalid
    end

    it "is valid with published set to true" do
      learning_path.published = true
      expect(learning_path).to be_valid
    end

    it "is valid with published set to false" do
      learning_path.published = false
      expect(learning_path).to be_valid
    end

    it "is invalid with a negative views count" do
      learning_path.views_count = -1
      expect(learning_path).to be_invalid
    end
    end

    describe "associations" do
      it "has many enrollments" do
        expect(learning_path).to respond_to(:enrollments)
      end

      it "has many talents through enrollments" do
        expect(learning_path).to respond_to(:talents)
      end

      it "has many learning_path_courses" do
        expect(learning_path).to respond_to(:learning_path_courses)
      end

      it "has many courses through learning_path_courses" do
        expect(learning_path).to respond_to(:courses)
      end

      it "destroys associated enrollments when destroyed" do
        FactoryBot.create(:enrollment, learning_path: learning_path)
        expect { learning_path.destroy }.to change { Enrollment.count }.by(-1)
      end

      it "destroys associated learning_path_courses when destroyed" do
        FactoryBot.create(:learning_path_course, learning_path: learning_path)
        expect { learning_path.destroy }.to change { LearningPathCourse.count }.by(-1)
      end
      describe "scopes" do
        before do
          FactoryBot.create_list(:learning_path, 3, published: true, views_count: 200)
          FactoryBot.create_list(:learning_path, 2, published: false)
          FactoryBot.create(:learning_path, published: true, views_count: 50)
          FactoryBot.create(:learning_path, published: true, views_count: 99)
        end

        let!(:published_path) { FactoryBot.create(:learning_path, published: true) }
        let!(:unpublished_path) { FactoryBot.create(:learning_path, published: false) }
        let!(:popular_path) { FactoryBot.create(:learning_path, views_count: 200) }
        let!(:unpopular_path) { FactoryBot.create(:learning_path, views_count: 50) }
        let!(:new_path) { FactoryBot.create(:learning_path, created_at: Time.now) }
        let!(:old_path) { FactoryBot.create(:learning_path, created_at: Time.now - 1.day) }

        describe '.published' do
          it 'returns only published paths' do
            LearningPath.destroy_all
            published_path = FactoryBot.create(:learning_path, published: true)
            FactoryBot.create(:learning_path, published: false)
            expect(LearningPath.published).to eq([published_path])
          end
        end

        describe '.unpublished' do
          it 'returns only unpublished paths' do
            LearningPath.destroy_all
            FactoryBot.create(:learning_path, published: true)
            unpublished_path = FactoryBot.create(:learning_path, published: false)
            expect(LearningPath.unpublished).to eq([unpublished_path])
          end
        end

        describe '.popular' do
          it 'returns only paths with views_count >= 100' do
            LearningPath.destroy_all
            popular_path = FactoryBot.create(:learning_path, views_count: 200)
            FactoryBot.create(:learning_path, views_count: 50)
            expect(LearningPath.popular).to eq([popular_path])
          end
        end

        describe '.newest_first' do
          it 'returns paths in descending order by FactoryBot.created_at' do
            LearningPath.destroy_all
            new_path =  FactoryBot.create(:learning_path, created_at: Time.now)
            old_path =  FactoryBot.create(:learning_path, created_at: Time.now - 1.day)

            expect(LearningPath.newest_first).to eq([new_path, old_path])
          end
        end

        describe '.oldest_first' do
          it 'returns paths in ascending order by FactoryBot.created_at' do
            LearningPath.destroy_all
            new_path =  FactoryBot.create(:learning_path, created_at: Time.now)
            old_path =  FactoryBot.create(:learning_path, created_at: Time.now - 1.day)

            expect(LearningPath.oldest_first).to eq([old_path, new_path])
          end
        end
      end

      describe 'class methods' do
        describe '.search' do
          let!(:path1) { FactoryBot.create(:learning_path, name: 'Learn Ruby on Rails') }
          let!(:path2) { FactoryBot.create(:learning_path, name: 'Learn React') }

          it 'returns only learning paths that match the search query' do
            expect(LearningPath.search('ruby')).to eq([path1])
          end
        end

        describe '.random' do
          let!(:path1) { FactoryBot.create(:learning_path) }
          let!(:path2) { FactoryBot.create(:learning_path) }

          it 'returns a random learning path' do
            expect([path1, path2]).to include(LearningPath.random)
          end
        end
      end
    end
  end
