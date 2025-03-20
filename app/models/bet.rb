class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :game
  validates :prediction, presence: true, inclusion: { in: %w[home away draw] }
end
