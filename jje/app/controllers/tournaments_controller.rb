class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :join]
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :join]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
  end

  # GET /tournaments/new
  def new
    unless current_user.admin?
      flash[:error] = 'Only administrators can create new tournaments.'
      redirect_to :tournaments_path
      return
    end
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
    unless current_user.admin?
      flash[:error] = 'Only administrators can edit tournaments.'
      redirect_to :tournament_path
      return
    end
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    unless current_user.admin?
      flash[:error] = 'Only administrators can create new tournaments.'
      redirect_to :tournaments_path
      return
    end

    @tournament = Tournament.new(tournament_params)

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /tournaments/1/join
  def join
    if @tournament.end < DateTime.current() then
      flash[:error] = "This tournament is already over."
    elsif CompetesIn.find_by(tournament_id: @tournament.tournament_id, user_id: current_user.user_id)
      flash[:notice] = "You're already in the tournament!"
    elsif CompetesIn.create(tournament_id: @tournament.tournament_id, user_id: current_user.user_id)
      flash[:success] = "You joined the tournament!"
    else
      flash[:error] = "An error occurred while joining."
    end
    redirect_to :tournament
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.fetch(:tournament, {})
    end
end
