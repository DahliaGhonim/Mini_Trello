class ChangeNameNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :boards, :name, false
    change_column_null :lists, :name, false
    change_column_null :cards, :title, false
  end
end
