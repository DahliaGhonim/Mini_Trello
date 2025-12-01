FactoryBot.define do
  factory :card do
    title { "myCard" }
    association :owner, factory: :list
  end
end
