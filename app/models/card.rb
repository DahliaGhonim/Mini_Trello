class Card < ApplicationRecord
  belongs_to :list, optional: true
  belongs_to :user
end
