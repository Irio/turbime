class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :user
      t.string :name
      t.text :description
      t.string :headline
      t.string :video
      t.string :repository
      t.string :code_funded
      t.float :goal
      t.datetime :expires_at
      t.boolean :visible

      t.timestamps
    end
    add_index :projects, :user_id
  end
end
