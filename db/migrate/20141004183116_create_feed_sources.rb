class CreateFeedSources < ActiveRecord::Migration
  def change
    create_table :feed_sources do |t|
      t.string :title
      t.string :url
      t.boolean :checked

      t.timestamps null: false
    end
    add_index :feed_sources, :title
  end
end
