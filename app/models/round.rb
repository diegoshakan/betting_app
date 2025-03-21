class Round < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :bets, through: :games
  has_many :round_winners
  has_many :winners, through: :round_winners, source: :user

  accepts_nested_attributes_for :games, allow_destroy: true, reject_if: :all_blank

  enum :status, { open: 0, closed: 1, finished: 2, in_progress: 3 }, default: :open

  validates :number, presence: true, uniqueness: true
end
