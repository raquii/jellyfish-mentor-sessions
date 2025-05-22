class AddAuthorToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :author, foreign_key: { to_table: :users }
  end
end
