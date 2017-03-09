class Tournament < ApplicationRecord
  self.primary_key = 'tournament_id'
  has_many :languages, :class_name => 'TournamentLanguages', :foreign_key => [:tournament_id]
end
