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
      redirect_to :tournaments, flash: {error: 'Only administrators can create new tournaments.'}
      return
    end
    @tournament = Tournament.new
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    unless current_user.admin?
      redirect_to :tournaments, flash: {error: 'Only administrators can create new tournaments.'}
      return
    end

    @tournament = Tournament.new(tournament_params)

    if @tournament.save
      # now create the TournamentLanguages
      TournamentLanguage::LanguageOptions.each do |(name, key)|
        if params['languages'][key] == "1"
          TournamentLanguage.create(language: name, tournament_id: @tournament.tournament_id)
        end
      end
      redirect_to @tournament, flash: {success: 'Tournament was created!'}
    else
      redirect_to @tournament, flash: {error: "Failed to create tournament: #{@tournament.errors.full_messages}"}
    end
  end

  # GET /tournaments/1/edit
  def edit
    unless current_user.admin?
      redirect_to :tournament, flash: {error: 'Only administrators can edit tournaments.'}
      return
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    unless current_user.admin?
      redirect_to @tournament, flash: {error: 'Only administrators can edit tournaments.'}
      return
    end

    Problem.where(problem_id: params[:problem_id]).each do |prob|
      unless Contain.exists?(tournament_id: @tournament.tournament_id, problem_id: prob.problem_id)
        contain = Contain.create(tournament_id: @tournament.tournament_id, problem_id: prob.problem_id)
      end
    end

    if @tournament.update(tournament_params)
      redirect_to :edit_tournament, flash: {success: 'Tournament was successfully updated.'}
    else
      redirect_to @tournament, flash: {error: "Failed to edit tournament: #{@tournament.errors.full_messages}"}
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    unless current_user.admin?
      redirect_to @tournament, flash: {error: 'Only administrators can delete tournaments.'}
      return
    end
    if @tournament.destroy
      redirect_to :tournaments, flash: {success: 'Tournament was successfully destroyed.'}
    else
      redirect_to @tournament, flash: {error: "Failed to delete tournament: #{@tournament.errors.full_messages}"}
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
    redirect_to @tournament
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :start, :end, :problems, :languages, 'start(1i)', 'start(2i)', 'start(3i)', 'start(4i)', 'start(5i)',
                                                'end(1i)',   'end(2i)',   'end(3i)',   'end(4i)',   'end(5i)')
    end
end
