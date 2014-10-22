class RemoveDescriptionAndEntryIdFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :description, :string
    remove_column :entries, :entry_id, :string
  end
end
