require "rails_helper"

describe "Admin courses", js: true do
  let!(:admin) { create(:admin) }
  let!(:labs) { create_list(:programming_lab, 3) }
  let!(:random_lab) { labs.sample }
  let!(:teachers) { create_list(:teacher, 3) }
  let!(:random_teacher) { teachers.sample }
  let!(:course) { create(:course) }

  before :each do
    login_as admin
  end

  describe "creation" do
    before :each do
      click_on "Admin"

      within(find("#admin-dropdown-menu")) do
        click_on "Create Course"
      end
    end

    context "when invalid" do
      before :each do
        click_on "Create Course"
      end

      it "displays an error notification" do
        expect(find(".alert-error")).to have_content("Course not successfully created")
      end

      it "indicates title can't be blank" do
        expect(find(".course_title")).to have_content("Title can't be blank")
      end

      it "indicates description can't be blank" do
        expect(find(".course_description")).to have_content("Description can't be blank")
      end
    end

    context "when valid" do
      before :each do
        fill_in "Title", with: "Course title"
        fill_in_rich_text "Description", with: "Course description"

        check random_lab.title
        check random_teacher.full_name

        click_on "Create Course"
      end

      it "adds the course to courses table" do
        expect(find("#courses")).to have_content("Course title")
      end

      it "shows successful creation notification" do
        expect(find(".alert-notice")).to have_content("You have successfully created course: Course title")
      end
    end
  end

  describe "deletion" do
    before :each do
      click_on course.title
      click_on "Delete"
    end

    it "shows successful deletion notification" do
      expect(find(".alert-notice")).to have_content("You have successfully deleted course: #{course.title}.")
    end

    it "removes course from courses table" do
      expect(find("#courses")).to have_content("No courses are currently stored in the database.")
    end
  end
end
