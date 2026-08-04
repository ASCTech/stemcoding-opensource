require "rails_helper"

describe "Student course gradebook", js: true do
  let(:enrollment) { create(:enrollment) }
  let(:course_lab) { create(:course_programming_lab, course: enrollment.course) }
  let(:submission) { create(:graded_submission, course_programming_lab: course_lab, author: enrollment) }

  before :each do
    submission

    login_as enrollment.student

    click_on course_lab.course_title
    click_on "Gradebook"
  end

  it "has the lab title for each course" do
    expect(page).to have_content(submission.lab_title)
  end

  it "has the grade for any submission in a course programming lab" do
    expect(page).to have_content(submission.grade)
  end

  it "has the instructor comment for any course programming lab submission" do
    expect(find("#course-lab-#{submission.course_programming_lab_id}")).to have_content(submission.instructor_comment)
  end
end
