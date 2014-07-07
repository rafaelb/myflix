Fabricator(:queue_item) do
  user
  video
  position { Faker::Number.digit }
end