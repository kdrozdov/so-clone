class AddImpressionsCountToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :impressions_count, :integer, default: 0
  end
end
