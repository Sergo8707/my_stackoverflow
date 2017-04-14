# frozen_string_literal: true
class DailyMailerPreview < ActionMailer::Preview
  def digest
    DailyMailerMailer.digest
  end
end
