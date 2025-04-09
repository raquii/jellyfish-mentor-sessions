class AddAuthorToModels < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :author, foreign_key: { to_table: :users }, null: false
    add_reference :articles, :author, foreign_key: { to_table: :users }, null: false
    # add_reference :comments, :author, foreign_key: { to_table: :users }, null: false
  end
end
