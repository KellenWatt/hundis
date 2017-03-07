class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :university
      t.integer :score
      t.string :company
      t.string :display_name
      t.string :email
      t.string :hash
      t.string :salt
      t.integer :ID

      t.timestamps
    end
  end
end
