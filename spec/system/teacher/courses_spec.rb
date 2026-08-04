require "rails_helper"

describe "Teacher courses", js: true do
  let(:teacher) { create(:teacher) }
  let!(:labs) { create_list(:programming_lab, 3) }
  let!(:random_lab) { labs.sample }
  let!(:course) { create(:course) }

  before :each do
    login_as teacher

    within(find('.btn-toolbar')) do
      click_on "Create course"
    end
  end

  describe "creation" do
    context "when invalid" do
      before :each do
        click_on "Create Course"
      end

      it "displays an error notification" do
        expect(find(".alert-error")).to have_content("Course not created")
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

        click_on "Create Course"
      end

      it "adds the course to courses table" do
        expect(find("#title")).to have_content("Course title")
      end

      it "shows successful creation notification" do
        expect(find(".alert-notice")).to have_content("has been created")
      end
    end
  end
end
