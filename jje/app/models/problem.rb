class Problem < ApplicationRecord
  self.primary_key = 'problem_id'
  has_many :keywords, :class_name => 'ProblemKeyword', dependent: :destroy
  has_many :tags, :class_name => 'ProblemTag', dependent: :destroy
  has_many :submissions, class_name: 'UserSubmission', dependent: :destroy
  has_many :tournaments, through: :contains
  has_many :contains
  
  def to_s
    "Name: #{self.name}, ID: #{self.problem_id}"
  end      

end
