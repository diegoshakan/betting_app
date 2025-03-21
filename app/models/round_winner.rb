class RoundWinner < ApplicationRecord
  belongs_to :round
  belongs_to :user

  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
