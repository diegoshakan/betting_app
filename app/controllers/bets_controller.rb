class BetsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_round_status, only: [ :new, :create ]
  before_action :set_bet, only: [ :edit, :update ]
  before_action :authorize_edit, only: [ :edit, :update ]

  def index
    @users = User.joins(bets: { game: :round })
                 .where(rounds: { status: "in_progress" })
                 .distinct # Remove duplicatas
                 .map { |user| [user, user.bets.joins(game: :round).where(rounds: { status: "in_progress" }).sum(&:score)] }
                 .sort_by { |_, score| -score } # Ordena por pontuação decrescente
  end

  def show_user_bets
    @user = User.find(params[:user_id])
    @bets = @user.bets.includes(:game) # Todas as apostas, sem filtro de status
  end

  def new
    @round = Round.find(params[:round_id])
    @games = @round.games
    @bets = @games.map { |game| current_user.bets.build(game: game) }
  end

  def create
    @round = Round.find(params[:round_id])
    @games = @round.games
    if save_bets
      redirect_to rounds_path, notice: "Apostas registradas com sucesso para #{@games.count} jogos!"
    else
      @bets = @games.map { |game| current_user.bets.build(game: game) }
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @game = @bet.game
    @round = @game.round
  end

  def update
    if @bet.update(bet_params_edit)
      redirect_to rounds_path, notice: "Aposta atualizada com sucesso!"
    else
      @game = @bet.game
      @round = @game.round
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def bet_params
    params[:bets]&.values || []
  end

  def bet_params_edit
    params.require(:bet).permit(:prediction)
  end

  def save_bets
    bet_params.each do |bet_data|
      next unless bet_data[:game_id] && bet_data[:prediction]
      bet = current_user.bets.find_or_initialize_by(game_id: bet_data[:game_id])
      bet.prediction = bet_data[:prediction]
      bet.save
    end
    true
  end

  def check_round_status
    round = Round.find(params[:round_id])
    unless round.open?
      redirect_to rounds_path, alert: "Apostas não permitidas para esta rodada (Status: #{round.status.capitalize})."
    end
  end

  def set_bet
    @bet = Bet.find(params[:id])
  end

  def authorize_edit
    round = @bet.game.round
    unless round.open? && (@bet.user == current_user || current_user.admin?)
      redirect_to rounds_path, alert: "Você não tem permissão para editar esta aposta."
    end
  end
end
