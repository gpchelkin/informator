class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :url
      t.string :text
      t.datetime :time
      t.references :FeedSource, index: true
      t.boolean :checked

      t.timestamps null: false
    end
    add_index :entries, :title
  end
end
