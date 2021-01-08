class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friends do |t|
      t.integer :follower_id
      t.integer :following_id

      t.timestamps
    end
    add_index :friends, :follower_id
    add_index :friends, :following_id
    add_index :friends, [:follower_id, :following_id], unique: true
  end
end
