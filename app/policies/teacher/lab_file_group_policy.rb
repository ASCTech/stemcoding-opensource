# frozen_string_literal: true

class Teacher::LabFileGroupPolicy < TeacherPolicy
  def show?
    super_teacher? || teacher?
  end

  private

    def lab_file_group
      record
    end

    def lab_taught_by_user?
      lab_file_group.lab_taught_by?(user)
    end

    def lab_authored_by_user?
      lab_file_group.lab_authored_by?(user)
    end
end
