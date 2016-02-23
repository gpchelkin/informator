class ChangeEmailNullOnAdmins < ActiveRecord::Migration
  def change
    change_column_null :admins, :email, true
  end
end
