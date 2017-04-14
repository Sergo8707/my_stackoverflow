# frozen_string_literal: true
class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.lastday
    mail(to: user.email, subject: 'Daily questions digest') if @questions.any?
  end
end
