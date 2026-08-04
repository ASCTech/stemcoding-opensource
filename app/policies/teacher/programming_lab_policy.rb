# frozen_string_literal: true

class Teacher::ProgrammingLabPolicy < TeacherPolicy
  class Scope < Scope
    def resolve
      super_teacher? || teacher? ? scope.all : scope.none
    end
  end

  def show?
    super_teacher? || teacher? || user_instructs_lab?
  end

  private

    def programming_lab
      record
    end

    def lab_authored_by_user?
      programming_lab.authored_by?(user)
    end

    def user_instructs_lab?
      user.instructor_for_lab?(programming_lab)
    end

    def lab_has_no_submissions?
      programming_lab.submissions.empty?
    end
end
