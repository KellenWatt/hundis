class CreateCompetesIns < ActiveRecord::Migration[5.0]
  def change
    create_table :competes_ins, id: false do |t|
    	t.integer :user_id, null: false
    	t.integer :tournament_id, null: false

      t.timestamps
    end
  end
end
