class ProblemsController < ApplicationController
  before_action :authenticate_user!, exclude: [:show]
  before_action :set_problem, only: [:show, :edit, :update, :showUpload, :uploadCode, :uploadOutput]

  # GET /problems/new
  def new
  end

  # POST /problems
  def create
    # TODO: handle problem creation
    unless current_user.admin?
      redirect_to :problems, flash: {error: 'Only administrators can create new problems.'}
    end
    keywords = params[:keywords][:allkeywords].split
    tags = params[:tags][:alltags].split
    # TODO: sanitize keywords/tags

    @problem = Problem.new(problem_params)
    if @problem.save
      keywords.each do |kw|
        @problem.keywords.create(keyword: kw)
      end
      tags.each do |tag|
        @problem.tags.create(tag: tag)
      end
      redirect_to @problem, flash: {success: 'Problem created!'}
    else
      redirect_to :new_problem, flash: {error: "Failed to create problem: #{@problem.errors.full_messages}"}
    end
  end

  # GET /problems/:id/edit
  def edit
    unless current_user.admin?
      redirect_to :problems, flash: {error: 'Only administrators can edit problems.'}
    end
    @keywordstring = @problem.keywords.collect(&:keyword).join(' ')
    @tagstring = @problem.tags.collect(&:tag).join(' ')
  end

  # PUT /problems/:id
  def update
    unless current_user.admin?
      redirect_to :problems, flash: {error: 'Only administrators can create new problems.'}
    end
    keywords = params[:keywords][:allkeywords].split
    tags = params[:tags][:alltags].split
    # TODO: sanitize keywords/tags

    if @problem.update(problem_params)
      @problem.keywords.clear
      keywords.each do |kw| @problem.keywords.create(keyword: kw) end
      @problem.tags.clear
      tags.each do |tag| @problem.tags.create(tag: tag) end

      redirect_to @problem, flash: {success: 'Problem updated!'}
    else
      redirect_to @problem, flash: {error: "Failed to update problem: #{@problem.errors.full_messages}"}
    end
  end

  # GET /problems/statistics
  def stats
    @problems = Problem.all
  end

  # GET /problems/:id
  def show
    #@keywords = ProblemKeyword.where(problem_id: params[:id])
    #@tags = ProblemTag.where(problem_id: params[:id])
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
