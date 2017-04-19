class CompetesInsController < ApplicationController
  before_action :set_competes_in, only: [:show, :edit, :update, :destroy]

  # GET /competes_ins
  # GET /competes_ins.json
  def index
    @competes_ins = CompetesIn.all
  end

  # GET /competes_ins/1
  # GET /competes_ins/1.json
  def show
  end

  # GET /competes_ins/new
  def new
    @competes_in = CompetesIn.new
  end

  # GET /competes_ins/1/edit
  def edit
  end

  # POST /competes_ins
  # POST /competes_ins.json
  def create
    @competes_in = CompetesIn.new(competes_in_params)

    respond_to do |format|
      if @competes_in.save
        format.html { redirect_to @competes_in, notice: 'Competes in was successfully created.' }
        format.json { render :show, status: :created, location: @competes_in }
      else
        format.html { render :new }
        format.json { render json: @competes_in.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competes_ins/1
  # PATCH/PUT /competes_ins/1.json
  def update
    respond_to do |format|
      if @competes_in.update(competes_in_params)
        format.html { redirect_to @competes_in, notice: 'Competes in was successfully updated.' }
        format.json { render :show, status: :ok, location: @competes_in }
      else
        format.html { render :edit }
        format.json { render json: @competes_in.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competes_ins/1
  # DELETE /competes_ins/1.json
  def destroy
    @competes_in.destroy
    respond_to do |format|
      format.html { redirect_to competes_ins_url, notice: 'Competes in was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competes_in
      @competes_in = CompetesIn.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competes_in_params
      params.fetch(:competes_in, {})
    end
end
