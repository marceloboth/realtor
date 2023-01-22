FactoryBot.define do
  factory :user do
    email { 'user@mail.com' }
    password { 'pass123' }
    password_confirmation { 'pass123' }
  end
end
