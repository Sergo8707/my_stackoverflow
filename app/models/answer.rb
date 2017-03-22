# frozen_string_literal: true
class Answer < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable
  belongs_to :question

  validates :body, :question, presence: true, length: { minimum: 10 }

  scope :first_best, -> { order('best DESC') }

  def mark_best
    ActiveRecord::Base.transaction do
      question.answers.where(best: true).find_each { |answer| answer.update!(best: false) }
      update!(best: true)
    end
  end
end
