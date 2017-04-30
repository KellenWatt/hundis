class Problem < ApplicationRecord
  self.primary_key = 'problem_id'
  has_many :keywords, :class_name => 'ProblemKeyword', :foreign_key => [:problem_id]
  has_many :tags, :class_name => 'ProblemTag', :foreign_key => [:problem_id]
      

end
