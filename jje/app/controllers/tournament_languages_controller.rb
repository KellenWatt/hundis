class TournamentLanguagesController < ApplicationController
  before_action :set_tournament_language, only: [:show, :edit, :update, :destroy]

  # GET /tournament_languages
  # GET /tournament_languages.json
  def index
    @tournament_languages = TournamentLanguage.all
  end

  # GET /tournament_languages/1
  # GET /tournament_languages/1.json
  def show
  end

  # GET /tournament_languages/new
  def new
    @tournament_language = TournamentLanguage.new
  end

  # GET /tournament_languages/1/edit
  def edit
  end

  # POST /tournament_languages
  # POST /tournament_languages.json
  def create
    @tournament_language = TournamentLanguage.new(tournament_language_params)

    respond_to do |format|
      if @tournament_language.save
        format.html { redirect_to @tournament_language, notice: 'Tournament language was successfully created.' }
        format.json { render :show, status: :created, location: @tournament_language }
      else
        format.html { render :new }
        format.json { render json: @tournament_language.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournament_languages/1
  # PATCH/PUT /tournament_languages/1.json
  def update
    respond_to do |format|
      if @tournament_language.update(tournament_language_params)
        format.html { redirect_to @tournament_language, notice: 'Tournament language was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament_language }
      else
        format.html { render :edit }
        format.json { render json: @tournament_language.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournament_languages/1
  # DELETE /tournament_languages/1.json
  def destroy
    @tournament_language.destroy
    respond_to do |format|
      format.html { redirect_to tournament_languages_url, notice: 'Tournament language was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament_language
      @tournament_language = TournamentLanguage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_language_params
      params.fetch(:tournament_language, {})
    end
end
