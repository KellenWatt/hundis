class ProblemTagsController < ApplicationController
  before_action :set_problem_tag, only: [:show, :edit, :update, :destroy]

  # GET /problem_tags
  # GET /problem_tags.json
  def index
    @problem_tags = ProblemTag.all
  end

  # GET /problem_tags/1
  # GET /problem_tags/1.json
  def show
  end

  # GET /problem_tags/new
  def new
    @problem_tag = ProblemTag.new
  end

  # GET /problem_tags/1/edit
  def edit
  end

  # POST /problem_tags
  # POST /problem_tags.json
  def create
    @problem_tag = ProblemTag.new(problem_tag_params)

    respond_to do |format|
      if @problem_tag.save
        format.html { redirect_to @problem_tag, notice: 'Problem tag was successfully created.' }
        format.json { render :show, status: :created, location: @problem_tag }
      else
        format.html { render :new }
        format.json { render json: @problem_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problem_tags/1
  # PATCH/PUT /problem_tags/1.json
  def update
    respond_to do |format|
      if @problem_tag.update(problem_tag_params)
        format.html { redirect_to @problem_tag, notice: 'Problem tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem_tag }
      else
        format.html { render :edit }
        format.json { render json: @problem_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problem_tags/1
  # DELETE /problem_tags/1.json
  def destroy
    @problem_tag.destroy
    respond_to do |format|
      format.html { redirect_to problem_tags_url, notice: 'Problem tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem_tag
      @problem_tag = ProblemTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_tag_params
      params.require(:problem_tag).permit(:problem_id, :tag)
    end
end
