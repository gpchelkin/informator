class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title
      t.string :summary
      t.boolean :checked

      t.timestamps null: false
    end
  end
end
