require "rails_helper"

describe "Super teacher programming labs", js: true do
  context "when creating a lab" do
    let(:super_teacher) { create(:super_teacher) }

    before :each do
      login_as super_teacher

      click_on "Teacher"
      click_on "Create Lab"

      fill_in "Title", with: "Programming Lab Title"

      within_frame(programming_lab_content_iframe) do
        programming_lab_content.set("[programming-lab-key]")
      end

      within_frame(programming_lab_teacher_notes_iframe) do
        programming_lab_teacher_notes.set("teacher notes")
      end

      click_on "Add Group"
      click_on "Add File"
      click_on "Add File"

      all(".programming-lab-file").first.attach_file(Rails.root.join("spec", "support", "files", "programming_lab", "sketch.js"))
      all(".programming-lab-file").last.attach_file(Rails.root.join("spec", "support", "files", "programming_lab", "functions.js"))

      within(file_groups) do
        fill_in "Title", with: "File Group Title"
        fill_in "Key", with: "programming-lab-key"
      end

      click_on "Create Programming lab"
    end

    it "notifies the user the lab has been created" do
      expect(notice).to have_content("You have successfully created programming lab: Programming Lab Title.")
    end
  end

  private

    def notice
      find(".alert-notice")
    end

    def file_groups
      find("#file-groups")
    end

    def programming_lab_content_iframe
      find("#programming_lab_content_ifr")
    end

    def programming_lab_content
      find("body[data-id='programming_lab_content']")
    end

    def programming_lab_teacher_notes_iframe
      find("#programming_lab_teacher_notes_ifr")
    end

    def programming_lab_teacher_notes
      find("body[data-id='programming_lab_teacher_notes']")
    end
end
