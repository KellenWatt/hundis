class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems, id: false do |t|
      t.primary_key :problem_id
      t.string :name
      t.integer :score
      t.text :problem_description
      t.string :path

      t.timestamps
    end
  end
end
