class LabFileGroupDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def key_string
    "[" + key + "]"
  end

  def link(namespace)
    h.link_to title, [namespace, file_group], target: :_blank, rel: :noopener
  end

  private

    alias file_group object
end
