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

50.times do |n|
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

50.times do |n|
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

students = Student.order(:created_at).take(6)
teachers = Teacher.order(:created_at).take(3)
subjects = ["算数", "国語", "理科", "社会", "数学", "英語" ]
20.times do |n|
	start_date = end_date = Date.today
	comment = Faker::Lorem.sentence(5)
	students.each do |student| 
		student.reports.create!(
			start_date: start_date, end_date: end_date,
			subject: subjects[n%6], comment: comment,
			teacher_id: 1
		)
	end
	teachers.each do |teacher| 
		teacher.reports.create!(
			start_date: start_date, end_date: end_date,
			subject: subjects[n%6], comment: comment,
			student_id: 1
		)
	end
end

20.times do |n|
	title = Faker::Lorem.sentence(5)
	content = Faker::Lorem.sentence(15)
	students.each do |student| 
		student.news.create!(
			title: title,
			content: content,
			status: 1,
			teacher_id: 1
		)
	end
	teachers.each do |teacher| 
		news = teacher.news.create!(
			title: title,
			content: content,
			status: 0
		)
		students[0].news << news
	end
end

