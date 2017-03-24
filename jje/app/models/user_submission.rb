class UserSubmission < ApplicationRecord
	self.primary_keys = :user_id, :problem_id, :timestamp
	belongs_to :user, :foreign_key => [:user_id]
	belongs_to :problem, :foreign_key => [:problem_id]
end
