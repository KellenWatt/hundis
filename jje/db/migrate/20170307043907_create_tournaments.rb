class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.integer :ID
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :checktime_flag
      t.text :supported_languages

      t.timestamps
    end
  end
end
