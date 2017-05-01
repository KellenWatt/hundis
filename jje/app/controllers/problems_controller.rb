class ProblemsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_problem, only: [:show, :edit, :update, :showUpload, :uploadCode, :uploadOutput, :downloadInput]
  require 'fileutils'

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
    keywords = params[:keywords][:allkeywords].split
    tags = params[:tags][:alltags].split
    # TODO: sanitize keywords/tags
    input_files = params[:files][:input]
    output_files = params[:files][:output]

    @problem = Problem.new(problem_params)
    if @problem.save
      keywords.each do |kw|
        @problem.keywords.create(keyword: kw)
      end
      tags.each do |tag|
        @problem.tags.create(tag: tag)
      end

      basepath = Rails.root.join("problems", "#{@problem.problem_id}")
      Dir.mkdir(basepath)
      Dir.mkdir(basepath.join('input'))
      Dir.mkdir(basepath.join('output'))
      input_files.each do |upfile|
        File.open(basepath.join('input', upfile.original_filename), 'wb') do |file|
          file.write(upfile.read)
        end
      end
      output_files.each do |upfile|
        File.open(basepath.join('output', upfile.original_filename), 'wb') do |file|
          file.write(upfile.read)
        end
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
    @input_path = Rails.root.join("problems","#{@problem.problem_id}", "input")
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
    sandhome = "/home/jjeuser"
    probnum = @problem.problem_id
    destpath = "users/#{current_user.user_id}/submissions/#{probnum}"
    probpath = "problems/#{probnum}"
    FileUtils.mkdir_p(destpath)
    File.open("#{destpath}/#{uploaded_main.original_filename}", 'wb') do |file|
      file.write(uploaded_main.read)
    end
    if uploaded_supp
      uploaded_supp.each do |upfile|
        File.open("#{destpath}/#{upfile.original_filename}", 'wb') do |file|
          file.write(upfile.read)
        end
      end
    end
    input = "#{sandhome}/input"
    output = "#{sandhome}/solutions"
    code = "#{sandhome}/code"
    sandbox = Docker::Container.create(
      'Image' => 'jje_sandbox:latest',
      'Volumes' => {input => {},
                    output => {}, 
                    code => {}}
    )
    sandbox.start('Binds' => ["#{probpath}/input:#{input}:ro", 
                               "#{probpath}/output:#{output}:ro", 
                               "#{ destpath}:#{code}:rw"],
                  'Cmd' => ["python3 grader.py #{sandhome}/code/#{uploaded_main.original_filename} #{uploaded_lang}"])
    # should return a value that we need to deal with.
    redirect_to @problem
  end

    # POST /problems/:id/submit/output
  def uploadOutput
    uploaded_output = params[:output]

    # TODO: handle submission
    sandhome = "/home/jjeuser"
    probnum = @problem.problem_id
    destpath = "users/#{current_user.user_id}/submissions/#{probnum}"
    probpath = "problems/#{probnum}"
    FileUtils.mkdir_p(destpath)
    File.open("#{destpath}/output", 'wb') do |file|
      file.write(uploaded_main.read)
    end
    
    output = "#{sandhome}/solutions"
    code = "#{sandhome}/code"
    sandbox = Docker::Container.create(
      'Image' => 'jje_sandbox:latest',
      'Volumes' => {"#{sandhome}/code" => {},
                    "#{sandhome}/output" => {}}
    )
    sandbox.start('Binds' => ["#{probpath}/output:#{output}:ro", 
                               "#{destpath}:#{code}:rw"],
                  'Cmd' => ["python3 grader.py --diff_files"])
    # should return a value that we need to deal with.
    redirect_to @problem
  end

  def downloadInput
    flname = File.basename(params[:flname])
    path = Rails.root.join("problems", "#{@problem.problem_id}", "input", flname)
    if File.exist?(path) then
      send_file path
    else
      raise ActionController::RoutingError, 'Input File Not Found'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    def problem_params
      params.require(:problem).permit(:name, :score, :description, files: {input: [], output: []})
    end
end
