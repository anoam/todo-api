FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "task title #{n}" }
    sequence(:description) { |n| "task description #{n}" }

    trait :completed do
      completed_at Time.now
    end
  end
end
