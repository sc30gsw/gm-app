FactoryBot.define do
  factory :man do
    name { Faker::Name.name }
    content { Faker::Lorem.sentence }
    category_id { 2 }
    address { Faker::Address.name }
    latitude { 180 }
    longitude { 180 }

    association :user

    after(:build) do |product|
      product.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
