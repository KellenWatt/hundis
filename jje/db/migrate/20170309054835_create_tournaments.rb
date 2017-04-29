class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments, id: false do |t|
      t.primary_key :tournament_id
      t.string :name, null: false
      t.datetime :start
      t.datetime :end
      t.boolean :checktime #If this is true, only submission between start and
                           #end will count toward score. Else, old submissions
                           #will count as well.

      t.timestamps
    end
    add_index :tournaments, :name, unique: true

    create_table :tournament_languages, id: false do |t|
      t.belongs_to :tournament, index: true
      t.integer :tournament_id, null: false
      t.string :language, null: false

      t.timestamps
    end
  end
end
