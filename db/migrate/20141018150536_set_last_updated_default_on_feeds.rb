class SetLastUpdatedDefaultOnFeeds < ActiveRecord::Migration
  def change
    change_column_default :feeds, :last_updated, Time.at(0)
  end
end
