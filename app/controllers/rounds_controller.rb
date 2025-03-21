class RoundsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:new, :create, :update_status]
  before_action :set_round, only: [:show, :update_status]

  def index
    @rounds = Round.all
  end

  def show
    @games = @round.games
  end

  def new
    @round = Round.new
    10.times { @round.games.build }
    @teams = Team.all
  end

  def create
    @round = Round.new(round_params)
    if @round.save
      redirect_to rounds_path, notice: "Rodada criada com sucesso!"
    else
      @teams = Team.all # Para recarregar os times em caso de erro
      render :new, status: :unprocessable_entity
    end
  end

  def update_status
    new_status = params[:status]
    if Round.statuses.key?(new_status) && @round.update(status: new_status)
      redirect_to rounds_path, notice: "Status da rodada atualizado para #{@round.status}!"
    else
      redirect_to rounds_path, alert: "Falha ao atualizar o status da rodada."
    end
  end

  private

  def round_params
    params.require(:round).permit(:number, games_attributes: [:id, :home_team_id, :away_team_id])
  end

  def set_round
    @round = Round.find(params[:id])
  end

  def ensure_admin
    redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
  end
end
