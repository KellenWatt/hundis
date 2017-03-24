class TournamentLanguage < ApplicationRecord
  self.primary_keys = :tournament_id, :language
  belongs_to :tournament, :foreign_key => [:tournament_id]
end
