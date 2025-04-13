FactoryBot.define do
  factory :show do
    dates { "2024-04-01" }
    venue { "The Venue" }
    location { "New York, NY" }
    link { "http://example.com/show" }
    note { "Great show!" }
    association :user
  end
end 