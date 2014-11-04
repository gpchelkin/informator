class AddLastUpdatedToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :last_updated, :datetime
  end
end
