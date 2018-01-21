FactoryBot.define do
  factory :task do
    trait :completed do
      completed_at Time.now
    end
  end
end
