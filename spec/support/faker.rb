require 'faker'

# Set the locale to use for Faker data
Faker::Config.locale = 'en-US'

# Add custom Faker data
Faker::UniqueGenerator.clear
Faker::UniqueGenerator.add('username') do
  Faker::Internet.unique.username(specifier: 4..20)
end
