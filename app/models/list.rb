class List < ApplicationRecord
  belongs_to :board
  has_many :cards, as: :owner, dependent: :destroy
end
