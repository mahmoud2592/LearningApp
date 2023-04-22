FactoryBot.define do
  factory :author do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    website_url { Faker::Internet.url }
  end
end
