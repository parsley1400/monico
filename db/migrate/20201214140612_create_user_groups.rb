class CreateUserGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :user_groups do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :wake_up, default: false, null: false

      t.timestamps
    end
  end
end
