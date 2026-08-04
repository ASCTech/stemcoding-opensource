require "rails_helper"

describe UserMailer do
  describe "#last_weeks_taught_submissions" do
    let!(:course_teacher) { create(:course_teacher) }
    let!(:teacher) { course_teacher.teacher }
    let!(:course) { course_teacher.course }

    let!(:course_labs) { create_list(:course_lab, 3, course: course) }
    let!(:course_lab_submissions) {
      course_labs.flat_map { |course_lab| create_list(:submission, 3, course_programming_lab: course_lab) }
    }

    let!(:course_titles) { course_lab_submissions.map(&:course_title) }
    let!(:email) { UserMailer.with(user: teacher).last_weeks_taught_submissions.deliver_now }

    describe "email recipient" do
      it "is the teacher's email" do
        expect(email.to).to include(teacher.email)
      end
    end

    describe "email subject" do
      it "includes last's week date and today's date" do
        expect(email.subject).to include 1.week.ago.to_date.strftime(UserMailer::DATE_FORMAT)
        expect(email.subject).to include Time.zone.now.to_date.strftime(UserMailer::DATE_FORMAT)
      end
    end

    describe "email body" do
      let(:html_body) { email.html_part.body.raw_source }
      let(:text_body) { email.text_part.body.raw_source }

      it "includes all course titles in the email's body" do
        expect(email.html_part.body.raw_source).to include(*course_titles)
        expect(email.text_part.body.raw_source).to include(*course_titles)
      end
    end
  end
end
