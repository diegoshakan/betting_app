# app/controllers/rounds_controller.rb
class RoundsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: [ :new, :create ]

  def index
    @rounds = Round.all
  end

  def show
    @round = Round.find(params[:id])
    @games = @round.games
  end

  def new
    @round = Round.new
    10.times { @round.games.build } # Garante 10 jogos vazios
    @teams = Team.all
  end

  def create
    @round = Round.new(round_params)
    if @round.save
      redirect_to rounds_path, notice: "Rodada criada com sucesso!"
    else
      @teams = Team.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def round_params
    params.require(:round).permit(:number, games_attributes: [ :id, :home_team_id, :away_team_id ])
  end

  def ensure_admin
    redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
  end
end
