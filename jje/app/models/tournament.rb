class Tournament < ApplicationRecord
  self.primary_key = 'tournament_id'
  has_many :languages, :class_name => 'TournamentLanguages', :foreign_key => [:tournament_id]
  has_many :contains, :class_name => 'Contains', :foreign_key => [:tournament_id]
  has_many :problems, through: :contains
  has_many :competes_ins, :class_name => 'CompetesIns', :foreign_key => [:tournament_id]
  has_many :users, through: :competes_ins
end
