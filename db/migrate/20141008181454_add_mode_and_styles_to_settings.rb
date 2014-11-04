class AddModeAndStylesToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :mode, :boolean
    add_column :settings, :style, :integer
  end
end
