class RemoveUserFromLists < ActiveRecord::Migration
  def change
    remove_column :lists, :user_id
  end
end
