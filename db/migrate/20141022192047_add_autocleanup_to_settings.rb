class AddAutocleanupToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :autocleanup, :boolean
  end
end
