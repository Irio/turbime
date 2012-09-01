class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.references :user
      t.references :project
      t.float :amount
      t.boolean :confirmed, default: false
      t.string :payment_token
      t.string :translaction_id
      t.string :payment_method

      t.timestamps
    end
    add_index :supports, :user_id
    add_index :supports, :project_id
  end
end
