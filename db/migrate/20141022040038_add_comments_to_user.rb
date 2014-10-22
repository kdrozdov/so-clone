class AddCommentsToUser < ActiveRecord::Migration
  def change
    add_column :comments, :author_id, :integer, null: false
    add_index :comments, :author_id
  end
end
