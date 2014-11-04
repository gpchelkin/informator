class AddDisplayFrequencyToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :display_frequency, :integer
    change_column_default :settings, :display_frequency, 10
  end
end
