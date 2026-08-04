# frozen_string_literal: true

require "rails_helper"

describe Submission do
  include ActiveSupport::Testing::TimeHelpers

  it { should have_many(:files).class_name("SubmissionFile").dependent(:destroy) }
  it { should accept_nested_attributes_for(:files).allow_destroy(true) }

  it { should have_db_column(:grade).of_type(:float) }
  it { should have_db_column(:student_comment).of_type(:text) }
  it { should have_db_column(:instructor_comment).of_type(:text) }

  let(:enrollment) { create(:enrollment) }
  let(:user) { enrollment.user }
  let(:course_lab) { create(:course_lab, course: enrollment.course) }

  describe ".previous_submissions" do
    it "retrieves a student's previous submissions for a lab" do
      travel_to 2.days.ago
      first_submission = create(:submission, course_programming_lab: course_lab, author: enrollment)

      create(:submission, author: enrollment)
      travel_back

      travel_to 1.day.ago
      second_submission = create(:submission, course_programming_lab: course_lab, author: enrollment)
      travel_back

      last_submission = create(:submission, course_programming_lab: course_lab, author: enrollment)

      expect(first_submission.previous_submissions).to be_empty
      expect(second_submission.previous_submissions.to_a).to eq([first_submission])
      expect(last_submission.previous_submissions.reorder_by_created_at.to_a).to eq([first_submission, second_submission])
    end
  end

  describe "#compose" do
    let(:submission) { build(:submission, author: enrollment) }

    it "returns the submission's display name" do
      expect(submission.compose).to eq "#{submission.author_full_name} ##{submission.chain_index}"
    end
  end

  describe "#graded?" do
    it "returns true when appropriate" do
      graded_submission = build(:graded_submission)
      expect(graded_submission.graded?).to be true
    end

    it "returns false when appropriate" do
      ungraded_submission = build(:ungraded_submission)
      expect(ungraded_submission.graded?).to be false
    end
  end

  let(:enrollment) { create(:enrollment) }
  let(:course_lab) { create(:course_lab, course: enrollment.course) }
  let(:first_sub) { create(:submission, course_programming_lab: course_lab, author: enrollment) }
  let(:mid_sub) { create(:submission, course_programming_lab: course_lab, author: enrollment) }
  let(:last_sub) { create(:submission, course_programming_lab: course_lab, author: enrollment) }

  describe "#last_descendent" do
    it "returns the last submission in the chain" do
      first_sub; mid_sub; last_sub

      expect(first_sub.last_descendent).to eq last_sub
      expect(mid_sub.last_descendent).to eq last_sub
      expect(last_sub.last_descendent).to eq last_sub
    end
  end

  describe "#first_ancestor" do
    it "returns the first submission in the chain" do
      first_sub; mid_sub; last_sub

      expect(first_sub.first_ancestor).to eq first_sub
      expect(mid_sub.first_ancestor).to eq first_sub
      expect(last_sub.first_ancestor).to eq first_sub
    end
  end

  describe "#first_ancestor?" do
    it "checks if this is the first submission in the chain" do
      first_sub; mid_sub; last_sub

      expect(first_sub.first_ancestor?).to be true
      expect(mid_sub.first_ancestor?).to be false
      expect(last_sub.first_ancestor?).to be false
    end
  end

  describe "#last_descendent?" do
    it "checks if this is the last submission in the chain" do
      first_sub; mid_sub; last_sub

      expect(first_sub.last_descendent?).to be false
      expect(mid_sub.last_descendent?).to be false
      expect(last_sub.last_descendent?).to be true
    end
  end

  describe "#chain_index" do
    it "returns the proper index of the submission" do
      first_sub; mid_sub; last_sub

      expect(first_sub.chain_index).to eq 1
      expect(mid_sub.chain_index).to eq 2
      expect(last_sub.chain_index).to eq 3
    end
  end
end
