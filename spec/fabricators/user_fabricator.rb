Fabricator(:user) do
  full_name { Faker::Name::name }
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password { Faker::Lorem::word }
  admin false
  stripe_token { Faker::Lorem::word }
end

Fabricator(:admin, from: :user) do
  admin true
end