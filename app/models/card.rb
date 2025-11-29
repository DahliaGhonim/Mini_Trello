class Card < ApplicationRecord
  belongs_to :owner, polymorphic: true
end
