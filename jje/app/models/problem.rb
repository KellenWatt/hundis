class Problem < ApplicationRecord
  self.primary_key = 'problem_id'
  has_many :keywords, :class_name => 'ProblemKeyword', dependent: :destroy
  has_many :tags, :class_name => 'ProblemTag', dependent: :destroy
end
