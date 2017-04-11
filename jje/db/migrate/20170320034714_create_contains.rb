class CreateContains < ActiveRecord::Migration[5.0]
  def change
    create_table :contains, id: false do |t|
      t.integer :tournament_id, null: false
      t.integer :problem_id, null: false

      t.timestamps
    end
  end
end
