# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments

  validates :body, :question, presence: true, length: { minimum: 10 }

  scope :first_best, -> { order('best DESC') }

  def mark_best
    ActiveRecord::Base.transaction do
      question.answers.where(best: true).find_each { |answer| answer.update!(best: false) }
      update!(best: true)
    end
  end
end
