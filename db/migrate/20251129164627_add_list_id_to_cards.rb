class AddListIdToCards < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :list_id, :integer
  end
end
