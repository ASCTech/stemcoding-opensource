class Student::Course::SignupPolicy < Course::SignupPolicy
  def create?
    student?
  end

  def permitted_attributes
    [:join_key]
  end
end
