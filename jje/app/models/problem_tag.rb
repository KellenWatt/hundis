class ProblemTag < ApplicationRecord
  self.primary_keys = :problem_id, :tag
  belongs_to :problem, :foreign_key => [:problem_id]
end
