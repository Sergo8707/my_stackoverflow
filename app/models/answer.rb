class Answer < ApplicationRecord
  belongs_to :question

  validates :body, :question, presence: true
end
