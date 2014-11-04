class RemoveAutotwoFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :auto, :boolean
  end
end
