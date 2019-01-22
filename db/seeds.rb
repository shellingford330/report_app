# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Student.create!( grade: "大学4年生",
								 name: "owner", 
								 email: "owner@jiyujyuku.com",
								 password: "jiyujyuku",
								 password_confirmation: "jiyujyuku" )

(0..3).each do |n|
	name = Faker::Name.name
	email = "student#{n+1}@jiyujyuku.com"
	password = "password"
	Student.create!( grade: "年少",
									name: name,
									email: email,
									password: password,
									password_confirmation: password )
end
(4..6).each do |n|
	name = Faker::Name.name
	email = "student#{n+1}@jiyujyuku.com"
	password = "password"
	Student.create!( grade: "年中",
									name: name,
									email: email,
									password: password,
									password_confirmation: password )
end
(7..10).each do |n|
	name = Faker::Name.name
	email = "student#{n+1}@jiyujyuku.com"
	password = "password"
	Student.create!( grade: "年長",
									name: name,
									email: email,
									password: password,
									password_confirmation: password )
end
(11..20).each do |n|
	name = Faker::Name.name
	email = "student#{n+1}@jiyujyuku.com"
	password = "password"
	Student.create!( grade: "小学#{n%3+1}年生",
									 name: name,
									 email: email,
									 password: password,
									 password_confirmation: password )
end
(21..30).each do |n|
	name = Faker::Name.name
	email = "student#{n+1}@jiyujyuku.com"
	password = "password"
	Student.create!( grade: "中学#{n%3+1}年生",
									 name: name,
									 email: email,
									 password: password,
									 password_confirmation: password )
end
(31..40).each do |n|
	name = Faker::Name.name
	email = "student#{n+1}@jiyujyuku.com"
	password = "password"
	Student.create!( grade: "高校#{n%3+1}年生",
									 name: name,
									 email: email,
									 password: password,
									 password_confirmation: password )
end
(41..50).each do |n|
	name = Faker::Name.name
	email = "student#{n+1}@jiyujyuku.com"
	password = "password"
	Student.create!( grade: "大学#{n%3+1}年生",
									 name: name,
									 email: email,
									 password: password,
									 password_confirmation: password )
end
