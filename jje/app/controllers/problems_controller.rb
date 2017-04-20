class ProblemsController < ApplicationController
  def index
  end
  
  def show
    @problem = Problem.find(params[:id])
    @keywords = ProblemKeyword.where(problem_id: params[:id])
    @tags = ProblemTag.where(problem_id: params[:id])
  end
  
  def stats
    @problems = Problem.all
  end
  
  def showUpload
    @problem = Problem.find(params[:id])
  end
  
  def uploadCode
    
  end
  
  def uploadOutput
    
  end
end
