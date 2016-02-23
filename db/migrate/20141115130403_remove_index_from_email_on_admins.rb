class RemoveIndexFromEmailOnAdmins < ActiveRecord::Migration
  def change
    remove_index :admins, :email
  end
end
