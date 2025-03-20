class Round < ApplicationRecord
  has_many :games, dependent: :destroy
  validates :number, presence: true, uniqueness: true

  accepts_nested_attributes_for :games, allow_destroy: true
end
