FactoryBot.define do
  factory :intro do
    profile { Faker::Lorem.sentence }
    website { Faker::Lorem.sentence }

    association :user

    after(:build) do |product|
      product.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
      product.image.attach(io: File.open('public/images/test_image2.png'), filename: 'test_image2.png')
    end
  end
end
