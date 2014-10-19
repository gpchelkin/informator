class RemoveDescriptionAndEntryIdFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :description, :string
    remove_column :feeds, :entry_id, :string
  end
end
