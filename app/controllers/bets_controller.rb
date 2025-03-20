# app/controllers/bets_controller.rb
class BetsController < ApplicationController
  before_action :authenticate_user!
  # before_action :ensure_admin, only: [:index]

  def index
    @users = User.joins(:bets).distinct # Lista apenas usuários com apostas
  end

  def show_user_bets
    @user = User.find(params[:user_id])
    @bets = @user.bets.includes(:game)
  end

  def new
    @round = Round.find(params[:round_id])
    @games = @round.games
    @bets = @games.map { |game| current_user.bets.build(game: game) }
    Rails.logger.debug "Número de apostas em @bets: #{@bets.count}"
  end

  def create
    Rails.logger.debug "Entrando no create com params: #{params.inspect}"
    @round = Round.find(params[:round_id])
    Rails.logger.debug "Rodada carregada: #{@round.inspect}"
    @games = @round.games
    Rails.logger.debug "Jogos carregados: #{@games.count}"
    Rails.logger.debug "Chamando save_bets"
    if save_bets
      Rails.logger.debug "Apostas salvas com sucesso"
      redirect_to rounds_path, notice: "Apostas registradas com sucesso para #{@games.count} jogos!"
    else
      Rails.logger.debug "Falha ao salvar apostas, renderizando new"
      @bets = @games.map { |game| current_user.bets.build(game: game) }
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bet_params
    Rails.logger.debug "Parâmetros de bets: #{params[:bets].inspect}"
    params[:bets]&.values || [] # Extrai os valores do hash "bets"
  end

  def save_bets
    Rails.logger.debug "Dados de bet_params: #{bet_params.inspect}"
    bet_params.each do |bet_data|
      Rails.logger.debug "Processando bet_data: #{bet_data.inspect}"
      next unless bet_data[:game_id] && bet_data[:prediction]
      bet = current_user.bets.find_or_initialize_by(game_id: bet_data[:game_id])
      bet.prediction = bet_data[:prediction]
      if bet.save
        Rails.logger.debug "Aposta salva: User #{current_user.id}, Game #{bet.game_id}, Prediction #{bet.prediction}"
      else
        Rails.logger.debug "Falha ao salvar aposta: #{bet.errors.full_messages.join(', ')}"
        return false
      end
    end
    true
  end

  def ensure_admin
    redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
  end
end
