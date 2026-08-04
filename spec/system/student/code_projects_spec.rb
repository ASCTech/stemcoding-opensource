require "rails_helper"

describe "Student code projects", js: true do
  let(:code_project_page) { Page::CodeProject.new(name: "Code project", description: "Project description") }
  let(:student) { create(:student) }

  context "when creating a new project" do
    before :each do
      login_as student

      code_project_page.create
    end

    it "notifies user the code project is successfully created" do
      expect(code_project_page).to have_success_notification
    end

    it "adds the code project to the page" do
      expect(code_project_page).to have_project
    end
  end

  context "when submitting a code project" do
    let(:enrollment) { create(:enrollment, student: student) }
    let(:course_lab) { create(:submittable_course_lab, course: enrollment.course) }
    let(:code_projects) { create_list(:code_project, 3, user: student) }

    before :each do
      code_projects
      enrollment
      course_lab

      login_as student

      click_on "Projects"

      within(find("#code-project-#{code_projects.first.id}")) do
        click_on "Submit"
      end

      choose course_lab.lab_title

      fill_in "Comments", with: "comments"
      click_on "Submit Project"
    end

    it "notifies user the code project was sucessfully submittied to a lab" do
      expect(find(".alert-notice")).to have_content("Code project submitted for programming lab, #{course_lab.title}")
    end
  end
end
