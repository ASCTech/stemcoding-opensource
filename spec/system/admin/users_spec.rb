require "rails_helper"

describe "Admin users", js: true do
  context "when an admin designates a user as a teacher" do
    it "notifies the admin the user has been updated" do
      admin = create(:admin)

      login_as admin

      click_on admin.full_name
      click_on "Edit"
      check "Teacher"
      click_on "Update User"

      expect(find(".alert-notice")).to have_content("User updated.")
    end
  end

  context "when and min designates a user as a super teacher" do
    it "notifies the admin the user has been update" do
      admin = create(:admin)
      user = create(:user)

      login_as admin

      click_on user.full_name

      click_on "Edit"

      check "Super teacher"

      click_on "Update User"

      expect(find(".alert-notice")).to have_content("User updated.")
    end
  end
end
