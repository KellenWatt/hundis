class TournamentLanguage < ApplicationRecord
  self.primary_keys = :tournament_id, :language
  belongs_to :problem, :foreign_key => [:problem_id]
end
