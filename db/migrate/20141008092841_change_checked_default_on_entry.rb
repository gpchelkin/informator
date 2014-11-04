class ChangeCheckedDefaultOnEntry < ActiveRecord::Migration
  def change
    change_column_default :entries, :checked, false
  end
end
