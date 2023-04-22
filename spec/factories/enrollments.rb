FactoryBot.define do
  factory :enrollment do
    association :talent
    association :learning_path
    enrollment_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
  end
end
