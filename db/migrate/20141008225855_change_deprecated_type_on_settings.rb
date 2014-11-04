class ChangeDeprecatedTypeOnSettings < ActiveRecord::Migration
  def change
    change_column :settings, :deprecated, :integer
  end
end
