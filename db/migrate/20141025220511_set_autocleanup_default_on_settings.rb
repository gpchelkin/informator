class SetAutocleanupDefaultOnSettings < ActiveRecord::Migration
  def change
    change_column_default :settings, :autocleanup, true
  end
end
