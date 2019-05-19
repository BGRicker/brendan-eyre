FactoryBot.define do
  factory :show do
    sequence(:dates) { |n| Date.current + n.days }
    venue { "Laugh Boston" }
    location { "Boston, MA" }
    link { "www.laughboston.com" }
    note { "Live recording of the podcast" }
  end

  factory :user do
    email { "bgricker@gmail.com" }
    password { 'grillingandchilling' }
  end

end
