Fabricator(:video) do
  title { sequence(:name) { |i| "Video #{i}" }}
  description { Faker::Lorem::paragraph(2) }
  category
end