# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question

  validates :body, :question, presence: true
end
