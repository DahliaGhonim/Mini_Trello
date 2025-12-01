class Card < ApplicationRecord
  belongs_to :owner, polymorphic: true
  validates :title, presence: true

  acts_as_list scope: :owner
  default_scope { order(position: :asc) }
end
