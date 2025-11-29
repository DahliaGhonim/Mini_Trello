class MakeCardsPolymorphicOwner < ActiveRecord::Migration[8.1]
  def change
    add_reference :cards, :owner, polymorphic: true, index: true, null: false
    remove_column :cards, :user_id
    remove_column :cards, :list_id
  end
end
