FactoryBot.define do
  factory :course do
    name { Faker::Educator.course_name }
    description { Faker::Lorem.paragraph }
    slug { Faker::Internet.slug }
    video_url { Faker::Internet.url }
    duration { Faker::Number.between(from: 1, to: 9999) }
    difficulty { Faker::Number.between(from: 1, to: 3) }
    price { Faker::Commerce.price }
    published { Faker::Boolean.boolean }
    association :learning_path
    association :author
  end
end
