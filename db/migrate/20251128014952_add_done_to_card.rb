class AddDoneToCard < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :done, :boolean, default: false
  end
end
