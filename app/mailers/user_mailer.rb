class UserMailer < ApplicationMailer
  DATE_FORMAT = "%a, %d %b %Y"

  def last_weeks_taught_submissions
    @user = params.fetch(:user)
    @submissions = @user.last_weeks_taught_submissions.decorate
    @last_week = 1.week.ago.to_date.strftime(DATE_FORMAT)
    @today = Time.zone.now.to_date.strftime(DATE_FORMAT)

    mail(to: @user.email, subject: "Stemcoding: Submissions for the week of #{@last_week} to #{@today}")
  end
end
