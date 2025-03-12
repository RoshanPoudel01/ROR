class CreateMusics < ActiveRecord::Migration[8.0]
  def change
    create_table :musics do |t|
      t.string :title, null: false
      t.string :album_name, null: false
      t.integer :genre
      t.belongs_to :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
