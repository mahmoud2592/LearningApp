FactoryBot.define do
  factory :course_talent do
    association :course
    association :talent
  end
end
