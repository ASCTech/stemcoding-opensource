require "rails_helper"

describe CourseLabMailer do
  subject(:mailer) { described_class }
  let(:lab) { create(:programming_lab, title: "Lab Title") }
  let(:course) { create(:course, title: "Course Title") }
  let(:course_lab) { create(:course_lab, programming_lab: lab) }
  let!(:enrollments) { create_list(:enrollment, 3, course: course_lab.course) }

  describe "#notify_students_of_status" do
    let!(:email) { mailer.with(course_lab: course_lab).notify_students_of_status.deliver_now }

    it "bccs student emails" do
      expect(email.bcc).to match_array(enrollments.map(&:email))
    end

    it "includes information about the course and lab in the email body" do
      email_body = email.html_part.body.to_s
      expect(email_body).to include(course_lab.lab_title)
      expect(email_body).to include(course_lab.course_title)
    end
  end

  context "when a course lab is opened to submissions" do
    it "notifies via the subject line that submissions can be submitted to course lab" do
      allow(course_lab).to receive(:submittable?) { true }
      email = mailer.with(course_lab: course_lab).notify_students_of_status.deliver_now

      expect(email.subject).to eq "Students can submit work to #{course_lab.title}"
    end
  end

  context "when a course lab is closed to submissions" do
    it "notifies via the subject line that submissions can not longer be submitted to course lab" do
      allow(course_lab).to receive(:submittable?) { false }
      email = mailer.with(course_lab: course_lab).notify_students_of_status.deliver_now

      expect(email.subject).to eq "Students can no longer submit work to #{course_lab.title}"
    end
  end
end
