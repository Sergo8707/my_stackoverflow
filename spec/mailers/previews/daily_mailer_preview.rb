class DailyMailerPreview < ActionMailer::Preview

  def digest
    DailyMailerMailer.digest
  end
end