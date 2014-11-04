class RemoveImageFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :image, :string
  end
end
