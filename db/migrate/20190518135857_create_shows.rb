class CreateShows < ActiveRecord::Migration[5.2]
  def change
    create_table :shows do |t|
      t.string :dates
      t.string :venue
      t.string :location
      t.string :link
      t.string :note
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
