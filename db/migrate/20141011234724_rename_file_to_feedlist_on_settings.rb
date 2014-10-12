class RenameFileToFeedlistOnSettings < ActiveRecord::Migration
  def change
    change_table :settings do |t|
      t.rename :file, :feedlist
    end
  end
end
