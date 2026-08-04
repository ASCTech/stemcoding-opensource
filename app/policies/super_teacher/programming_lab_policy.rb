class SuperTeacher::ProgrammingLabPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      super_teacher? ? scope.all : scope.none
    end
  end

  def show?
    super_teacher?
  end

  def create?
    super_teacher?
  end

  def update?
    super_teacher? &&
      lab_authored_by_user?
  end

  def permitted_attributes
    [
      :title,
      :content,
      :template,
      :teacher_notes,
      :use_norandom_p5,
      file_groups_attributes: [
        :id,
        :downloadable,
        :key,
        :title,
        :_destroy,
        files_attributes: [
          :id,
          :file,
          :_destroy,
        ],
      ],
    ]
  end

  private

    def programming_lab
      record
    end

    def lab_authored_by_user?
      programming_lab.authored_by?(user)
    end

    def lab_has_no_submissions?
      !programming_lab.has_submissions?
    end
end
