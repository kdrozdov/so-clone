class AddAnswersToUser < ActiveRecord::Migration
  def change
    add_column :answers, :author_id, :integer, null: false
    add_index :answers, :author_id
  end
end
