# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# The following comments are how to create a seed
# User(user_id: integer, university: string, score: integer,
# company: string, display_name: string, email: string, password: string,
# salt: string, created_at: datetime, updated_at: datetime)

User.create!(score: 9001, display_name: 'ADMIN', email: 'admin@admin', password: 'adminadmin', admin: true)
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

Problem.create!(name: 'Hello, World!', score: 1, problem_description: 'stuff', path: 'some path')
Problem.create!(name: 'Mystery Bag', score: 5, problem_description: 'stuff and', path: 'some path')
Problem.create!(name: 'Cat Toss', score: 3, problem_description: 'stuff and things', path: 'some path')
Problem.create!(name: 'Maze Run', score: 40, problem_description: 'stuff and thing like', path: 'some path')
Problem.create!(name: 'Beep Boop', score: 35, problem_description: 'stuff and things like that', path: 'some path')
Problem.create!(name: 'Choo-Choo', score: 20, problem_description: 'stuff and things like that for', path: 'some path')
Problem.create!(name: 'Limbo', score: 5, problem_description: 'stuff and things like that for all', path: 'some path')
Problem.create!(name: 'Chaos', score: 8, problem_description: 'stuff and things like that for all people', path: 'some path')
Problem.create!(name: 'Domination', score: 10, problem_description: 'stuff and things like that for all people on', path: 'some path')
Problem.create!(name: 'Entertainer', score: 50, problem_description: 'stuff and things like that for all people on Earth', path: 'some path')

sot = Tournament.create!(name: 'Some Old Tourney', start: DateTime.new(2012, 1, 15, 12), end: DateTime.new(2012, 5, 1), checktime: true)
et  = Tournament.create!(name: 'Eternal Tournament', start: DateTime.new(1955, 5, 15), end: DateTime.new(2030, 5, 15), checktime: true)
fg  = Tournament.create!(name: 'Future Gamez', start: DateTime.new(2018, 1, 1), end: DateTime.new(2018, 12, 1), checktime: true)

for lang in [ 'C', 'Lisp', 'Pascal' ] do
  TournamentLanguage.create!(tournament_id: sot.tournament_id, language: lang)
end
for lang in [ 'C', 'C++', 'Go', 'JavaScript', 'Haskell'] do
  TournamentLanguage.create!(tournament_id: et.tournament_id, language: lang)
end
TournamentLanguage.create!(tournament_id: fg.tournament_id, language: 'Python')


# User(user_id: integer, university: string, score: integer, company: string, display_name: string, email: string, password: string, salt: string, created_at: datetime, updated_at: datetime, encrypted_password: string, reset_password_token: string, reset_password_sent_at: datetime, remember_created_at: datetime, sign_in_count: integer, current_sign_in_at: datetime, last_sign_in_at: datetime, current_sign_in_ip: inet, last_sign_in_ip: inet)
# User(user_id: integer, university: string, score: integer, company: string, display_name: string, email: string, password: string, salt: string, created_at: datetime, updated_at: datetime)
