# frozen_string_literal: true

# This decorator assists with displaying the a Course.
class CourseDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  # TODO: Write a spec for this.

  # @return This returns the description of the course marked as html_safe
  def safe_description
    object[:description].html_safe
  end
end
