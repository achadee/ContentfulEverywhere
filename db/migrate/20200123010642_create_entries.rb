class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.string :entry_id
      t.text :data
      t.datetime :created_on_contentful_at
      t.timestamps
    end

    # add indexes so we can write and read super fast!
    add_index :entries, :entry_id, unique: true
    add_index :entries, :created_on_contentful_at
  end
end
