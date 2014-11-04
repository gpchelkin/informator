class SetLastUpdatedNullOnFeeds < ActiveRecord::Migration
  def change
    change_column_null :feeds, :last_updated, false
  end
end
