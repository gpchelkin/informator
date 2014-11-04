class RemoveLastFetchedFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :last_fetched, :datetime
  end
end
