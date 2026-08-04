class CourseProgrammingLabDecorator < ApplicationDecorator
  delegate_all
  decorates_association :programming_lab

  delegate :safe_display_content, to: :programming_lab
end
