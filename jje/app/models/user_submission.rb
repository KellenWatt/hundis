class UserSubmission < ApplicationRecord
	self.primary_keys = :user_id, :problem_id, :timestamp
	belongs_to :user
	belongs_to :problem
end
