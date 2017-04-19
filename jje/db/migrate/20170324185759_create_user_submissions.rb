class CreateUserSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_submissions, id: false do |t|
      t.datetime :timestamp, null: false
      t.integer :user_id, null: false
      t.integer :problem_id, null: false
      t.boolean :solved
      t.string :language
      t.decimal :runtime


      t.timestamps
    end
  end
end
