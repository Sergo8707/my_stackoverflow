# frozen_string_literal: true
class Answer < ApplicationRecord
  include Votable
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, :question, presence: true, length: { minimum: 10 }

  scope :first_best, -> { order('best DESC') }

  def mark_best
    ActiveRecord::Base.transaction do
      question.answers.where(best: true).find_each { |answer| answer.update!(best: false) }
      update!(best: true)
    end
  end
end
