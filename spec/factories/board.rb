FactoryBot.define do
  factory :board do
    sequence(:title) { |n| "board title #{n}" }
    sequence(:description) { |n| "board description #{n}" }
  end
end
