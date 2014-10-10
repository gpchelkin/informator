class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url
      t.boolean :use

      t.timestamps null: false
    end
  end
end
