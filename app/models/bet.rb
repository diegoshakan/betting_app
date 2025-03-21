class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :game
  validates :prediction, presence: true, inclusion: { in: %w[home away draw] }
  validates :game_id, uniqueness: { scope: :user_id, message: "Você já apostou neste jogo" }

  # Calcula a pontuação da aposta
  def score
    return 0 if game.result.nil? # Sem resultado ainda
    prediction == game.result ? 1 : 0
  end
end
