FactoryBot.define do
  factory :board do
    name { "myBoard" }
    sequence(:id) { |n| n }
    user
  end
end
