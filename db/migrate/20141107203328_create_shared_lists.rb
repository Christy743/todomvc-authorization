class CreateSharedLists < ActiveRecord::Migration
  def change
    create_table :shared_lists do |t|
      t.integer :user_id
      t.integer :list_id
      t.integer :permission

      t.timestamps null: false
    end
  end
end
