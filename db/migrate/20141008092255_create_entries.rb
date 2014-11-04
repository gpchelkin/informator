class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :url
      t.string :title
      t.string :summary
      t.string :description
      t.datetime :published
      t.boolean :checked
      t.references :feed, index: true

      t.timestamps null: false
    end
  end
end
