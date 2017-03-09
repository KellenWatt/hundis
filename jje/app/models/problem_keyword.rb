class ProblemKeyword < ApplicationRecord
  self.primary_keys = :problem_id, :keyword
  belongs_to :problem, :foreign_key => [:problem_id]
end
