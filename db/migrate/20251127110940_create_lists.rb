class CreateLists < ActiveRecord::Migration[8.1]
  def change
    create_table :lists do |t|
      t.references :board, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
