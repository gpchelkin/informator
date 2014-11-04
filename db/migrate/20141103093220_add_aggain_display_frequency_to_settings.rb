class AddAggainDisplayFrequencyToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :display_frequency, :float
    change_column_default :settings, :display_frequency, 0.5
  end
end
