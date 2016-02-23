class AddUsernameToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :username, :string
    change_column_null :admins, :username, false
  end
end
