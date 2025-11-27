class AddUserToCards < ActiveRecord::Migration[8.1]
  def change
    add_reference :cards, :user, null: false, foreign_key: true
  end
end
