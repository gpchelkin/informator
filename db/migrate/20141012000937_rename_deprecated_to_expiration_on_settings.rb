class RenameDeprecatedToExpirationOnSettings < ActiveRecord::Migration
  def change
    change_table :settings do |t|
      t.rename :deprecated, :expiration
    end
  end
end
