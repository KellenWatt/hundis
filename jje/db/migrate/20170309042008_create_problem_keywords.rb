class CreateProblemKeywords < ActiveRecord::Migration[5.0]
  def change
    create_table :problem_keywords, id: false do |t|
      t.integer :problem_id, null: false
      t.string :keyword, null: false

      t.timestamps
    end
  end
end
