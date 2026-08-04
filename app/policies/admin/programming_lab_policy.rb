# frozen_string_literal: true

class Admin::ProgrammingLabPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      admin? ? scope.all : scope.none
    end
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
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
end
