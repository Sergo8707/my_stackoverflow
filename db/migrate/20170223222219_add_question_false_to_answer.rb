# frozen_string_literal: true
class AddQuestionFalseToAnswer < ActiveRecord::Migration[5.0]
  def change
    change_column :answers, :question_id, :integer, null: false
  end
end
