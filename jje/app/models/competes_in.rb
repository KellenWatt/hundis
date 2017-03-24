class CompetesIn < ApplicationRecord
	self.primary_keys = :user_id, :tournament_id
	belongs_to :tournament, :foreign_key => [:tournament_id]
	belongs_to :user, :foreign_key => [:user_id]
end
