class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems, id: false do |t|
      t.primary_key :problem_id
      t.string :name
      t.integer :score
      t.text :problem_description
      t.string :path
    end

    create_table :problem_keywords, id: false do |t|
      t.belongs_to :problem, index: true
      t.integer :problem_id, null: false
      t.string :keyword, null: false
    end

    create_table :problem_tags, id: false do |t|
      t.belongs_to :problem, index: true
      t.integer :problem_id, null: false
      t.string :tag, null: false
    end
  end
end
