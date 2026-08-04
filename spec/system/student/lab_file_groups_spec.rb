require "rails_helper"

describe "Student lab file groups", js: true do
  describe "viewing" do
    let!(:course_lab) { create(:course_lab) }
    let(:student) { create(:enrollment, course: course_lab.course).student }

    context "when downloadable" do
      let!(:lab_file_group) { create(:downloadable_file_group, programming_lab: course_lab.programming_lab) }

      before :each do
        sketch_js = File.open(Rails.root.join("spec", "support", "files", "programming_lab", "sketch.js"))
        functions_js = File.open(Rails.root.join("spec", "support", "files", "programming_lab", "functions.js"))
        lab_file_group.files.create(file: sketch_js)
        lab_file_group.files.create(file: functions_js)

        login_as student

        visit student_lab_file_group_path(lab_file_group)
      end

      it "displays the file group's title" do
        expect(find("#lab-file-group")).to have_content(lab_file_group.title)
      end

      it "shows a list of files" do
        expect(find("#files-list")).to have_content("sketch.js")
        expect(find("#files-list")).to have_content("functions.js")
      end

      it "displays possible lab actions" do
        expect(find("#lab-actions")).to have_content("Edit")
      end
    end

    context "when not downloadable" do
      let!(:lab_file_group) { create(:nondownloadable_file_group, programming_lab: course_lab.programming_lab) }

      before :each do
        sketch_js = File.open(Rails.root.join("spec", "support", "files", "programming_lab", "sketch.js"))
        functions_js = File.open(Rails.root.join("spec", "support", "files", "programming_lab", "functions.js"))
        lab_file_group.files.create(file: sketch_js)
        lab_file_group.files.create(file: functions_js)

        login_as student

        visit student_lab_file_group_path(lab_file_group)
      end

      it "only shows the player" do
        expect(page).to_not have_content(lab_file_group.title)
        expect(page).to_not have_content("sketch.js")
        expect(page).to_not have_content("functions.js")
      end
    end
  end
end
