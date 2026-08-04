# frozen_string_literal: true

class ChangeCourseTeacherToNewSystem < ActiveRecord::Migration[5.0]
  def up
    # NOTE: This should run here, but it fails, and thus needs to be ran by hand.
    # Course.all.each do |course|
    #   if course.teacher
    #     course.teachers << course.teacher
    #     course.save!
    #   end
    # end
  end

  def down
  end
end
