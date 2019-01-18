# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Student.create!( name: "owner", 
								 email: "owner@jiyujyuku.com",
								 password: "jiyujyuku",
								 password_confirmation: "jiyujyuku" )

49.times do |n|
	name = Faker::Name.name
	email = "student#{n+1}@jiyujyuku.com"
	password = "password"
	Student.create!( name: name,
									 email: email,
									 password: password,
									 password_confirmation: password )
end