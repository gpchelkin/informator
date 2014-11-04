class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :frequency
      t.boolean :auto
      t.string :file

      t.timestamps null: false
    end
  end
end
