# frozen_string_literal: true

require "rails_helper"

describe "Admin labs", js: true do
  let(:admin) { create(:admin) }

  describe "creation" do
    let(:lab_attributes) { attributes_for(:programming_lab) }
    let(:file_group_attributes) { attributes_for(:lab_file_group) }

    before :each do
      login_as admin

      click_on "Create Programming Lab"

      fill_in "Title", with: lab_attributes.fetch(:title)

      fill_in_rich_text "Content", with: "$$\\frac{a}{b}$$"

      within(find(".programming_lab_content")) { click_on "Insert" }
      find("[aria-label='Code sample...']").click
      find("button[aria-label='Language']").click
      find("[aria-label='JavaScript']").click

      fill_in "Code view", with: "var x = 0;"
      click_on "Save"

      fill_in_rich_text "Teacher Notes", with: lab_attributes.fetch(:teacher_notes)

      click_on "Add Group"
      check "Downloadable"

      click_on "Add File"

      attach_file(Rails.root.join("spec", "support", "files", "programming_lab", "sketch.js"), class: "programming-lab-file")

      file_groups = find("#file-groups")

      within(file_groups) do
        fill_in "Title", with: file_group_attributes.fetch(:title)
        fill_in "Key", with: file_group_attributes.fetch(:key)
      end

      click_on "Create Programming lab"
    end

    it "displays success notification" do
      expect(find(".alert")).to have_content("You have successfully created programming lab: #{lab_attributes.fetch(:title)}.")
    end
  end

  describe "updating" do
    let!(:lab) { create(:lab, teacher_notes: "Teacher notes 1") }
    let(:lab_attributes) { attributes_for(:lab) }

    before :each do
      login_as admin

      click_on lab.title

      click_on "Edit"
      fill_in "Title", with: lab_attributes.fetch(:title)
      click_on "Update Programming lab"
    end

    it "updates the lab title" do
      expect(page).to have_content(lab_attributes.fetch(:title))
    end

    it "notifies the lab has been updated" do
      expect(find(".alert-notice")).to have_content("You have successfully updated programming lab: #{lab_attributes.fetch(:title)}.")
    end
  end

  describe "deletion" do
    let!(:lab) { create(:lab) }

    before :each do
      login_as admin
    end

    it "displays successful deletion notification" do
      click_on lab.title
      click_on "Delete"

      expect(find(".alert-notice")).to have_content("You have successfully deleted programming lab: #{lab.title}.")
    end

    it "removes the programming lab" do
      click_on "Programming Labs"
      expect(find("#programming-labs")).to have_content(lab.title)

      click_on lab.title
      click_on "Delete"

      expect(find("#programming-labs")).to_not have_content(lab.title)
    end
  end
end
