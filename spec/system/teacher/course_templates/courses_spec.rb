# frozen_string_literal: true

require "rails_helper"

describe "Teacher course templates course", js: true do
  context "when a course is created from a template" do
    let(:teacher) { create(:teacher) }
    let(:template) { create(:course_template, teachers: [teacher]) }
    let(:labs) { create_list(:programming_lab, 3, courses: [template]) }
    let(:course_attributes) { attributes_for(:course) }

    before :each do
      template
      labs

      login_as teacher

      click_on "View templates"
      click_on template.compose

      click_on "Clone this course"

      fill_in "Title", with: course_attributes.fetch(:title)

      click_on "Create Course"
    end

    it "notifies teacher course is successfully cloned from template" do
      expect(find(".alert-notice")).to have_content("Cloned course, #{course_attributes.fetch(:title)}, from template: #{template.compose}")
    end

    it "adds course to courses section of page" do
      expect(page).to have_content(course_attributes.fetch(:title))
    end
  end
end
