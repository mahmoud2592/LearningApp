FactoryBot.define do
  factory :talent do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    category { Talent.categories.keys.sample }
    level { Talent.levels.keys.sample }
    website_url { Faker::Internet.url }
  end
end
