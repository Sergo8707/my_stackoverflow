# frozen_string_literal: true
class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'questions'
  end
end
