class List < ApplicationRecord
  belongs_to :board
  validates :name, presence: true
  has_many :cards, as: :owner, dependent: :destroy
end
