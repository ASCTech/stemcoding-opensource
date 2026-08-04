namespace :users do
  desc "Update users' course_teachers_count"
  task update_course_teachers_count: :environment do
    Rails.logger.info "Update users' course_teachers_count"

    User.find_each do |user|
      User.reset_counters(user.id, :course_teachers)
      Rails.logger.info user.reload
    end

    Rails.logger.info "Finished updating users' course_teachers_count"
  end

  desc "Email a digest"
  task email_last_weeks_submissions: :environment do
    User.teaches_courses.find_each do |user|
      last_weeks_submissions = user.last_weeks_taught_submissions

      if last_weeks_submissions.exists?
        UserMailer.with(user: user).last_weeks_taught_submissions.deliver_now
      end
    end
  end
end
