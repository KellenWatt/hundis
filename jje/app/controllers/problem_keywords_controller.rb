class ProblemKeywordsController < ApplicationController
  before_action :set_problem_keyword, only: [:show, :edit, :update, :destroy]

  # GET /problem_keywords
  # GET /problem_keywords.json
  def index
    @problem_keywords = ProblemKeyword.all
  end

  # GET /problem_keywords/1
  # GET /problem_keywords/1.json
  def show
  end

  # GET /problem_keywords/new
  def new
    @problem_keyword = ProblemKeyword.new
  end

  # GET /problem_keywords/1/edit
  def edit
  end

  # POST /problem_keywords
  # POST /problem_keywords.json
  def create
    @problem_keyword = ProblemKeyword.new(problem_keyword_params)

    respond_to do |format|
      if @problem_keyword.save
        format.html { redirect_to @problem_keyword, notice: 'Problem keyword was successfully created.' }
        format.json { render :show, status: :created, location: @problem_keyword }
      else
        format.html { render :new }
        format.json { render json: @problem_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problem_keywords/1
  # PATCH/PUT /problem_keywords/1.json
  def update
    respond_to do |format|
      if @problem_keyword.update(problem_keyword_params)
        format.html { redirect_to @problem_keyword, notice: 'Problem keyword was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem_keyword }
      else
        format.html { render :edit }
        format.json { render json: @problem_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problem_keywords/1
  # DELETE /problem_keywords/1.json
  def destroy
    @problem_keyword.destroy
    respond_to do |format|
      format.html { redirect_to problem_keywords_url, notice: 'Problem keyword was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem_keyword
      @problem_keyword = ProblemKeyword.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_keyword_params
      params.require(:problem_keyword).permit(:problem_id, :keyword)
    end
end
