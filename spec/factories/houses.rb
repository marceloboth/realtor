FactoryBot.define do
  factory :house do
    bathrooms { 2 }
    bedrooms { 2 }
    price { 2000.6 }
    address { 'somewhere' }
    real_state { 'real state 1' }
    origin_url { 'https://realstate.com/house/1' }
    image { 'https://realstate.com/house/1/image.png' }
  end
end
