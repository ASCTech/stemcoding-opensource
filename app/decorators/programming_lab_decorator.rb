# frozen_string_literal: true

class ProgrammingLabDecorator < ApplicationDecorator
  delegate_all
  decorates_association :file_groups

  # Displays the content of programming lab. If any file group keys are embedded
  # in the content (e.g. [key]), they will be replaced with a link to the file
  # groups.
  #
  # @return [String] This returns processed content of the programming lab.
  def display_content(namespace)
    h.copy_code_button.html_safe +
      content.tap do |content|
        file_groups.each do |fg|
          content.gsub!(fg.key_string, fg.link(namespace))
        end
      end.html_safe
  end

  # @return [ActionSupport::SafeBuffer] This returns a html_safe version of display_content
  def safe_display_content(namespace)
    display_content(namespace).html_safe
  end

  private

    def programming_lab
      object
    end
end
