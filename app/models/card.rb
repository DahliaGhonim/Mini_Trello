class Card < ApplicationRecord
  acts_as_list
  belongs_to :owner, polymorphic: true
end
