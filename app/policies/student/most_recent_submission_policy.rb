class Student::MostRecentSubmissionPolicy < Student::SubmissionPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
