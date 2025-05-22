class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :int, default: 0
  end
end
