class UserSubmissionsController < ApplicationController
  before_action :set_user_submission, only: [:show, :edit, :update, :destroy]

  # GET /user_submissions
  # GET /user_submissions.json
  def index
    @user_submissions = UserSubmission.all
  end

  # GET /user_submissions/1
  # GET /user_submissions/1.json
  def show
  end

  # GET /user_submissions/new
  def new
    @user_submission = UserSubmission.new
  end

  # GET /user_submissions/1/edit
  def edit
  end

  # POST /user_submissions
  # POST /user_submissions.json
  def create
    @user_submission = UserSubmission.new(user_submission_params)

    respond_to do |format|
      if @user_submission.save
        format.html { redirect_to @user_submission, notice: 'User submission was successfully created.' }
        format.json { render :show, status: :created, location: @user_submission }
      else
        format.html { render :new }
        format.json { render json: @user_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_submissions/1
  # PATCH/PUT /user_submissions/1.json
  def update
    respond_to do |format|
      if @user_submission.update(user_submission_params)
        format.html { redirect_to @user_submission, notice: 'User submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_submission }
      else
        format.html { render :edit }
        format.json { render json: @user_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_submissions/1
  # DELETE /user_submissions/1.json
  def destroy
    @user_submission.destroy
    respond_to do |format|
      format.html { redirect_to user_submissions_url, notice: 'User submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_submission
      @user_submission = UserSubmission.where(user_id: params[:user_id], problem_id: params[:problem_id], timestamp: params[:timestamp]).first
      @problem = Problem.find(params[:problem_id])
      @user = User.find(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_submission_params
      params.fetch(:user_submission, {})
    end
end
