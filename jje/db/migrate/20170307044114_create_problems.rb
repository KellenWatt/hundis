class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.integer :ID
      t.string :name
      t.integer :score
      t.text :keyword
      t.text :problem_description
      t.string :path
      t.text :tags

      t.timestamps
    end
  end
end
