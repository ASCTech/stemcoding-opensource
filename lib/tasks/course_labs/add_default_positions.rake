namespace :course_labs do
  desc "Add default positions to course labs"
  task add_default_positions: :environment do
    Course.find_each do |course|
      course.course_programming_labs
        .where(position: nil)
        .joins(:programming_lab)
        .merge(CourseProgrammingLab.reorder_by_updated_at)
        .find_each.with_index(1) do |course_lab, index|
          course_lab.update(position: index)
          pp course_lab
        end
    end
  end
end
