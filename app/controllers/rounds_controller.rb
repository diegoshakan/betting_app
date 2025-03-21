class RoundsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: [ :new, :create, :update_status ]
  before_action :set_round, only: [ :show, :update_status ]

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
      @teams = Team.all
      render :new, status: :unprocessable_entity
    end
  end

  def update_status
    new_status = params[:status]
    if Round.statuses.key?(new_status)
      @round.transaction do
        @round.update!(status: new_status)
        if new_status == "finished"
          calculate_and_save_winners
        end
      end
      redirect_to rounds_path, notice: "Status da rodada atualizado para #{@round.status}!"
    else
      redirect_to rounds_path, alert: "Falha ao atualizar o status da rodada."
    end
  end

  private

  def round_params
    params.require(:round).permit(:number, games_attributes: [ :id, :home_team_id, :away_team_id ])
  end

  def set_round
    @round = Round.find(params[:id])
  end

  def ensure_admin
    redirect_to root_path, alert: "Acesso negado!" unless current_user.admin?
  end

  def calculate_and_save_winners
    scores = User.joins(bets: { game: :round })
                 .where(rounds: { id: @round.id })
                 .group("users.id")
                 .pluck(Arel.sql("users.id, SUM(CASE " +
                                 "WHEN bets.prediction = 'home' AND games.home_team_score > games.away_team_score THEN 1 " +
                                 "WHEN bets.prediction = 'away' AND games.home_team_score < games.away_team_score THEN 1 " +
                                 "WHEN bets.prediction = 'draw' AND games.home_team_score = games.away_team_score THEN 1 " +
                                 "ELSE 0 END)"))
                 .to_h

    return if scores.empty?

    max_score = scores.values.max
    winners = scores.select { |_, score| score == max_score }

    winners.each do |user_id, score|
      @round.round_winners.create!(user_id: user_id, score: score)
    end
  end
end
