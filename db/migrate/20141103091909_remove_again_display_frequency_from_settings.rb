class RemoveAgainDisplayFrequencyFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :display_frequency, :integer
  end
end
