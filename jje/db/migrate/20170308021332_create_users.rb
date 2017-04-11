class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: false do |t|
      t.primary_key :user_id #primary_key defaults to integer
      t.string :university
      t.integer :score
      t.string :company
      t.string :display_name, null: false
      t.string :email
      t.string :pass
      t.string :salt

      t.timestamps
    end
  end
end
