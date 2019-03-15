# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

owner = Teacher.new( status: 2,
								 name: "オーナー", 
								 email: "owner@example.com",
								 password: "jiyujyuku",
								 password_confirmation: "jiyujyuku" )
owner.save(validate: false)

Teacher.create!( status: 1,
								 name: "管理者", 
								 email: "manager@example.com",
								 password: "manager",
								 password_confirmation: "manager" )

Teacher.create!( status: 0,
								 name: "講師", 
								 email: "teacher@example.com",
								 password: "teacher",
								 password_confirmation: "teacher" )

20.times do |n|
	name = Faker::Name.name
	email = "teacher#{n+1}@example.com"
	password = "password"
	Teacher.create!( status: 0,
								 name: name, 
								 email: email,
								 password: password,
								 password_confirmation: password )
end

Student.create!( grade: "年少",
								 name: "生徒代表", 
								 email: "student@example.com",
								 password: "student",
								 password_confirmation: "student" )

20.times do |n|
	name = Faker::Name.name
	email = "student#{n+1}@example.com"
	grades = Student.grades
	password = "password"
	Student.create!( grade: grades[n%19],
								 name: name, 
								 email: email,
								 password: password,
								 password_confirmation: password )
end

