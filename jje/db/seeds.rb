# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


	# The following comments are how to create a sseed
# User(user_id: integer, university: string, score: integer,
# company: string, display_name: string, email: string, password: string,
# salt: string, created_at: datetime, updated_at: datetime)

User.create!(university: 'Missouri S&T', score: 0, display_name: 'Sam', email: 'Sam@mst.edu', password: 'liabsrtjsrtksrh')
User.create!(university: 'Missouri S&T', score: 10, display_name: 'John', email: 'John@gmail.com', password: 'ohsrtjsrtjsuag')
User.create!(university: 'Missouri S&T', score: 50, display_name: 'Kellen', email: 'Kellen@gmail.com', password: 'ohstrkstksuag')
User.create!(university: 'Missouri S&T', score: 5, display_name: 'Jordan', email: 'Jordan@gmail.com', password: 'ostrkshuag')
User.create!(university: 'Missouri S&T', score: 70, display_name: 'Shawn', email: 'Shawn@gmail.com', password: 'osrtjartkahuag')
User.create!(university: 'Missouri S&T', score: 35, display_name: 'Kyle', email: 'Kyle@gmail.com', password: 'ohutjdtykag')
User.create!(university: 'Missouri S&T', score: 62, display_name: 'James', email: 'James@gmail.com', password: 'trstrjsr')
User.create!(university: 'Missouri S&T', score: 100, display_name: 'Justin', email: 'Justin@gmail.com', password: 'dytkdk')
User.create!(university: 'Missouri S&T', score: 90, display_name: 'Morgan', email: 'Morgan@gmail.com', password: 'tykdldu')
User.create!(university: 'Missouri S&T', score: 200, display_name: 'Ashley', email: 'Ashley@gmail.com', password: 'srtjstyk')
User.create!(university: 'Missouri S&T', score: 350, display_name: 'Grace', email: 'Grace@gmail.com', password: 'srkstksy')
User.create!(university: 'Missouri S&T', score: 600, display_name: 'Maranda', email: 'Maranda@gmail.com', password: 'stjfaj')

Problem.create!(name: 'Test_problem_1', score: 1, problem_description: 'stuff', path: 'some path')
Problem.create!(name: 'Test_problem_2', score: 1, problem_description: 'stuff and', path: 'some path')
Problem.create!(name: 'Test_problem_3', score: 1, problem_description: 'stuff and things', path: 'some path')
Problem.create!(name: 'Test_problem_4', score: 1, problem_description: 'stuff and thing like', path: 'some path')
Problem.create!(name: 'Test_problem_5', score: 1, problem_description: 'stuff and things like that', path: 'some path')
Problem.create!(name: 'Test_problem_6', score: 1, problem_description: 'stuff and things like that for', path: 'some path')
Problem.create!(name: 'Test_problem_7', score: 1, problem_description: 'stuff and things like that for all', path: 'some path')
Problem.create!(name: 'Test_problem_8', score: 1, problem_description: 'stuff and things like that for all people', path: 'some path')
Problem.create!(name: 'Test_problem_9', score: 1, problem_description: 'stuff and things like that for all people on', path: 'some path')
Problem.create!(name: 'Test_problem_10', score: 1, problem_description: 'stuff and things like that for all people on Earth', path: 'some path')

# User(user_id: integer, university: string, score: integer, company: string, display_name: string, email: string, password: string, salt: string, created_at: datetime, updated_at: datetime, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime, sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: inet, last_sign_in_ip: inet)
# User(user_id: integer, university: string, score: integer, company: string, display_name: string, email: string, password: string, salt: string, created_at: datetime, updated_at: datetime)
