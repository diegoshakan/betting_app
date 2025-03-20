# app/models/game.rb
class Game < ApplicationRecord
  belongs_to :round
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  has_many :bets, dependent: :destroy
  validates :home_team_id, :away_team_id, presence: true
  validate :different_teams

  private

  def different_teams
    errors.add(:away_team, "não pode ser o mesmo que o time da casa") if home_team_id == away_team_id
  end
end
