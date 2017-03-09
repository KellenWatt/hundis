class CreateProblemTags < ActiveRecord::Migration[5.0]
  def change
    create_table :problem_tags, id: false do |t|
      t.integer :problem_id, null: false
      t.string :tag, null: false

      t.timestamps
    end
  end
end
