class AddDeprecatedToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :deprecated, :time
  end
end
