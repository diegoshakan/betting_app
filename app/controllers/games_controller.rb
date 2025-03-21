class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:edit_result, :update_result]
  before_action :set_game, only: [:edit_result, :update_result]

  def edit_result; end

  def update_result
    if @game.update(game_result_params)
      redirect_to round_path(@game.round), notice: "Resultado atualizado com sucesso!"
    else
      render :edit_result, status: :unprocessable_entity
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_result_params
    params.require(:game).permit(:home_team_score, :away_team_score)
  end

  def ensure_admin
    redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
  end
end
