class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: false do |t|
      t.primary_key :user_id #primary_key defaults to integer
      t.string :university
      t.integer :score, default: 0
      t.string :company
      t.string :display_name, null: false
      t.string :email
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
