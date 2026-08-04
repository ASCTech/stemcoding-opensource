namespace :courses do
  desc "Reset course labs count on courses"
  task reset_course_labs_count: :environment do
    Course.reset_column_information
    Course.all.each do |course|
      Course.reset_counters course.id, :course_programming_labs

      pp course
    end
  end
end
