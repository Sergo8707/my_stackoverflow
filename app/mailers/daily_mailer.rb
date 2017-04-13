class DailyMailer <ApplicationMailer
  def digest(user)
    @questions = Question.lastday
    if @questions.any?
      mail(to: user.email, subject: 'Daily questions digest')
    end
  end
end