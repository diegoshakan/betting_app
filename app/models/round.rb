class Round < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :bets, through: :games

  accepts_nested_attributes_for :games, allow_destroy: true

  enum :status, { open: 0, closed: 1, finished: 2 }, default: :open

  validates :number, presence: true, uniqueness: true
end
