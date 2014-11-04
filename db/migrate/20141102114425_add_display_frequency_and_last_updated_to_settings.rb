class AddDisplayFrequencyAndLastUpdatedToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :display_frequency, :integer
    change_column_default :settings, :display_frequency, 10
    add_column :settings, :last_updated, :datetime
    change_column_default :settings, :last_updated, Time.at(0)
  end
end
