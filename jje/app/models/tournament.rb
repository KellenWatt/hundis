class Tournament < ApplicationRecord
  self.primary_key = 'tournament_id'
  has_many :languages, :class_name => 'TournamentLanguage'
  has_many :contains
  has_many :problems, through: :contains
  has_many :competes_ins
  has_many :users, through: :competes_ins

  accepts_nested_attributes_for :languages
end
