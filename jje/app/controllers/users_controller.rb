class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :submissions]

  def index
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @tournaments = Tournament.joins(:competes_ins).where(["user_id = %i", @user.user_id])
    @solves = Problem.joins(:submissions).where(["user_id = %i and solved", @user.user_id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
    unless @user == current_user or (user_signed_in? and current_user.admin) then
      redirect_to @user, flash: {error: "Can only edit your own user!"}
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/submissions
  def submissions
    @submissions = @user.submissions
  end

  # *VERB* /users/:username/(*all)  =>  *VERB* /users/:id/:all
  def name_to_id
      @user = User.where(display_name: params[:username]).first
      if @user
        redirect_to "/users/#{@user.user_id}/#{params[:all]}"
      else
        raise ActiveRecord::RecordNotFound
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:display_name, :university, :company)
    end
end
