class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :division, presence: true
  has_many :home_games, class_name: "Game", foreign_key: "home_team_id"
  has_many :away_games, class_name: "Game", foreign_key: "away_team_id"
end
