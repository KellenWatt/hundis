class Contain < ApplicationRecord
  self.primary_keys = :problem_id, :tournament_id
  belongs_to :tournament, :foreign_key => [:tournament_id]
  belongs_to :problem, :foreign_key => [:problem_id]
end
