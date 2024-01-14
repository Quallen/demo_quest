FactoryBot.define do
  factory :character do
    association :user
    alive { true }
    name { 'First Last' }
    gender_identity { 'Male' }
    date_of_birth { 30.years.ago }

    trait :deceased do
      alive { false }
      deceased_at { Time.now }
    end
  end
end
