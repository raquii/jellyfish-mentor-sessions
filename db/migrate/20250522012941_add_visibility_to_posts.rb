class AddVisibilityToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :visibility, :int, null: false, default: 0
  end
end
