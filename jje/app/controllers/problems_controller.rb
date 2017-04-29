class ProblemsController < ApplicationController
  before_action :authenticate_user!, exclude: [:show]
  before_action :set_problem, only: [:show, :showUpload, :uploadCode, :uploadOutput]

  # GET /problems/new
  def new
    unless current_user.admin?
      redirect_to :tournaments, flash: {error: 'Only administrators can create new problems.'}
    end
    @problem = Problem.new
  end

  # POST /problems
  def create
    unless current_user.admin?
      redirect_to :problems, flash: {error: 'Only administrators can create new problems.'}
    end
    @problem = Problem.new(problem_params)
  end

  # GET /problems/statistics
  def stats
    @problems = Problem.all
  end

  # GET /problems/:id
  def show
    @keywords = ProblemKeyword.where(problem_id: params[:id])
    @tags = ProblemTag.where(problem_id: params[:id])
  end

  # GET /problems/:id/submit
  def showUpload
  end

  # POST /problems/:id/submit/code
  def uploadCode
    uploaded_lang = params[:language]
    uploaded_main = params[:main]
    uploaded_supp = params[:support]

    # TODO: handle submission
    destpath = 'the/destination/path'
    File.open(destpath.join(uploaded_main.original_filename), 'wb') do |file|
      file.write(uploaded_main.read)
    end
    uploaded_supp.each do |upfile|
      File.open(destpath.join(upfile.original_filename), 'wb') do |file|
        file.write(upfile.read)
      end
    end
  end

    # POST /problems/:id/submit/output
  def uploadOutput
    uploaded_output = params[:output]

    # TODO: handle submission
    destpath = 'the/destination/path'
    File.open(destpath.join("output"), 'wb') do |file|
      file.write(uploaded_main.read)
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    def problem_params
      params.require(:problem).permit(:name, :score, :description)
    end
end
