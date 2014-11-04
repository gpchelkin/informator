class AddEntryIdAndImageToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entry_id, :string
    add_column :entries, :image, :string
  end
end
