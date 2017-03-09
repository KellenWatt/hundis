class CreateTournamentLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_languages, id: false do |t|
      t.integer :tournament_id, null: false
      t.string :language, null: false

      t.timestamps
    end
  end
end
