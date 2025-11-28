class AddDescriptionToCard < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :description, :text
  end
end
