FactoryBot.define do
  factory :learning_path_course do
    association :learning_path
    association :course
    sequence(:number) { |n| n }
    required { Faker::Boolean.boolean }
    status { %w[not_started in_progress completed].sample }
    start_date { Faker::Date.between(from: 1.week.ago, to: Date.today) }
    end_date { Faker::Date.between(from: 1.week.from_now, to: 2.weeks.from_now) }
    rating { Faker::Number.between(from: 1, to: 5) }
    completed_at { Faker::Date.between(from: 1.week.ago, to: Date.today) }
  end
end
