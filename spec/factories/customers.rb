FactoryBot.define do
  factory :customer do
    first_name { Faker::DcComics.hero }
    last_name { Faker::DcComics.heroine }
  end
end
