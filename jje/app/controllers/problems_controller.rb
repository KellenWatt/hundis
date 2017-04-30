class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :showUpload, :uploadCode, :uploadOutput]

  # GET /problems/new
  def new
  end

  # POST /problems
  def create
    # TODO: handle problem creation
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
    probpath = 'the/problem/path'
    probnum = 'something'
    File.open(destpath.join(uploaded_main.original_filename), 'wb') do |file|
      file.write(uploaded_main.read)
    end
    uploaded_supp.each do |upfile|
      File.open(destpath.join(upfile.original_filename), 'wb') do |file|
        file.write(upfile.read)
      end
    end
    input = "/home/jjeuser/input"
    output = "/home/jjeuser/output"
    code = "/home/jjeuser/code"
    sandbox = Docker::Container.create(
      'Image' => 'jje_sandbox:latest',
      'Volumes' => {input => {},
                    output => {},
                    code => {}}
    )
    sandbox.start('Binds' => {["#{probpath}/input:#{input}:ro", 
                               "#{probpath}/output:#{output}:ro", 
                               "#{destpath}:#{code}:rw"]})
    # should return a value that we need to deal with.
  end

    # POST /problems/:id/submit/output
  def uploadOutput
    uploaded_output = params[:output]

    # TODO: handle submission
    destpath = 'the/destination/path'
    File.open(destpath.join("output"), 'wb') do |file|
      file.write(uploaded_main.read)
    end
    sandbox = Docker::Container.create(
      'Image' => 'jje_sandbox:latest',
      'Volumes' => {"/home/jjeuser/code" => {},
                    "/home/jjeuser/output" => {}}
    )
    sandbox.start('Binds' => {["#{probpath}/output:#{output}:ro", 
                               "#{destpath}:#{code}:rw"]})
    # should return a value that we need to deal with.
  end


  private
     # Use callbacks to share common setup or constraints between actions.
     def set_problem
       @problem = Problem.find(params[:id])
     end
end
