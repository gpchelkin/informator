class AddLastFetchedToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :last_fetched, :datetime
    change_column_default :feeds, :last_fetched, Time.at(0)
  end
end
