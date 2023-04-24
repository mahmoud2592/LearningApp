FactoryBot.define do
  factory :learning_path do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    duration_in_weeks { Faker::Number.between(from: 1, to: 9999) }
    difficulty_level { LearningPath.difficulty_levels.keys.sample }
    published { Faker::Boolean.boolean }
    views_count { Faker::Number.between(from: 1, to: 9999) }

    factory :learning_path_with_courses do
      transient do
        courses_count { 5 }
      end

      after(:create) do |learning_path, evaluator|
        create_list(:learning_path_course, evaluator.courses_count, learning_path: learning_path)
      end
    end
  end
end
