Fabricator(:queue_item) do
  user
  video
  position { [1,2,3].sample }
end