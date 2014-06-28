# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
cat1 = Fabricate(:category)
cat2 = Fabricate(:category)
cat3 = Fabricate(:category)
cat4 = Fabricate(:category)
cat5 = Fabricate(:category)
5.times{ Fabricate(:video, category: cat1) }
5.times{ Fabricate(:video, category: cat2) }
5.times{ Fabricate(:video, category: cat3) }
5.times{ Fabricate(:video, category: cat4) }
5.times{ Fabricate(:video, category: cat5) }
5.times{ Fabricate(:video, category: cat1) }
5.times{ Fabricate(:video, category: cat2) }
5.times{ Fabricate(:video, category: cat3) }
5.times{ Fabricate(:video, category: cat4) }
5.times{ Fabricate(:video, category: cat5) }
