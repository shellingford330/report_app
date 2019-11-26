# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

owner = Teacher.new(	status: 2,
											name: "オーナー", 
											email: "owner@example.com",
											activated: true,
											activated_at: Time.zone.now,
											password: "jiyujyuku",
											password_confirmation: "jiyujyuku" )
owner2 = Teacher.new(	status: 2,
											name: "owenr2", 
											email: "owner2@example.com",
											activated: true,
											activated_at: Time.zone.now,
											password: "jiyujyuku",
											password_confirmation: "jiyujyuku" )
owner.save(validate: false)
owner2.save(validate: false)