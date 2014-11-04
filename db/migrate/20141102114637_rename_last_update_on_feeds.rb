class RenameLastUpdateOnFeeds < ActiveRecord::Migration
  def change
    change_table :feeds do |t|
      t.rename :last_updated, :last_fetched
    end
  end
end
