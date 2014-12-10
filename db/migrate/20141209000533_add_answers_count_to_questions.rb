class AddAnswersCountToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answers_count, :integer, default: 0

    Question.find_each.each { |question| Question.reset_counters(question.id, :answers) }
  end
end
