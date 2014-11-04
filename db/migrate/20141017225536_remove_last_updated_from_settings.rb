class RemoveLastUpdatedFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :last_updated, :datetime
  end
end
