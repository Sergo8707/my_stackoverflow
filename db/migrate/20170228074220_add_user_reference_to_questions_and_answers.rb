# frozen_string_literal: true
class AddUserReferenceToQuestionsAndAnswers < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :user, foreign_key: true
    add_reference :answers, :user, foreign_key: true
  end
end
