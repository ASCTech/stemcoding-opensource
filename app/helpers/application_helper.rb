# frozen_string_literal: true

module ApplicationHelper
  #
  # @param string [String]
  #
  def title(string)
    content_for(:title, string)
  end

  def page_title(text, &block)
    css_classes = %w[
      d-flex
      justify-content-between
      flex-wrap
      flex-md-nowrap
      align-items-center
      pt-3
      pb-2
      mb-3
      border-bottom
    ].join(" ")

    content_tag(:div, class: css_classes) do
      content_tag(:h2, text, class: "h2") + block&.call
    end
  end

  ##
  # Code obtained from GradCentral from:
  #     gradcentral/app/helpers/application_helper.rb
  # on the dev branch head: 923bcbcfd0eff4e97d3dbb6899e5463c80da802f
  # Code was developed by Nick Hurst of ASCTech Development Team at
  # The Ohio State University and used via oral permission. ( Internal
  # organization code, no written permission required. )
  #
  # Helper method to generate Vue.js components inside haml/erb templates
  #
  # @param component  [String] Vue component to create
  # @param v_bind     [Hash]   Props that are passed with v-bind syntax
  # @param opts       [Hash]   Additional attributes to pass to component
  #
  # @return [String] HTML
  #
  def tabs(id:, **options, &block)
    id = "#{id}-tabs"

    classes = options.delete(:class)

    opts = {
      id: id,
      class: ["nav", "nav-tabs", classes].join(" "),
      role: "tablist",
    }.deep_merge(options)

    content_tag(:ul, **opts) do
      block&.call
    end
  end

  # Generate html for bootstrap's tab
  def tab(id:, active: false, **options, &block)
    html_classes = [
      (active ? "active" : ""),
      "nav-link",
    ].join(" ")

    id = id.parameterize

    html_options = {
      id: "#{id}-tab",
      class: html_classes,
      href: "##{id}",
      data: { toggle: "tab" },
      aria: { controls: id, selected: active },
      role: "tab",
    }.deep_merge(options)

    content_tag(:li, class: "nav-item") do
      content_tag(:a, html_options) do
        block&.call
      end
    end
  end

  def tab_content(id:, &block)
    content_tag(:div, class: "tab-content", id: "#{id.parameterize}Content") do
      block&.call
    end
  end

  def tab_pane(id:, active: false, **options, &block)
    html_classes = [
      active ? "active" : nil,
      "tab-pane",
    ].compact.join(" ")

    id = id.parameterize

    opts = {
      id: id.parameterize,
      class: html_classes,
      role: "tabpanel",
      aria: { labelledby: "#{id}-tab" },
    }.deep_merge(options)

    content_tag(:div, **opts) do
      block&.call
    end
  end

  def dropdown_toggle(id:, classes: [], html_element: :button, &block)
    html_classes = %w[
      btn
      dropdown-toggle
    ].concat(Array(classes)).join(" ")

    content_tag(html_element.to_sym, id: id, class: html_classes, type: "button", data: { toggle: "dropdown" }, aria: { haspopup: true, expanded: false }) do
      block&.call
    end
  end

  def badge(context:, id: nil, **options, &block)
    options = { class: "badge text-bg-#{context}" }.tap do |opts|
      opts[:id] = id if id.present?
      opts.merge!(options)
    end

    content_tag(:span, **options) do
      block.call if block.present?
    end
  end

  def button_group(aria_label:, &block)
    content_tag(:div, class: "btn-group", role: "group", arial: { label: aria_label }) do
      block.call if block.present?
    end
  end

  def fa_icon(icon, **options, &block)
    classes = [
      "fas",
      "fa-#{icon}",
    ] << options[:class]

    classes.join(" ")

    content_tag(:i, class: classes) do
      block.call if block.present?
    end
  end

  def copy_code_button
    classes = %w[
      clipboard
      btn
      btn-secondary
      btn-sm
      position-absolute
    ].join(" ")

    options = {
      type: :button,
      role: :button,
      style: "top: 0; right: 0;",
      data: {
        toggle: :popover,
        trigger: :focus,
        title: "Copied to clipboard!",
        content: "Copied to clipboard!",
      },
      tabindex: 0,
    }

    content_tag(:template, id: "copy-button") do
      content_tag(:button, class: classes, **options) do
        fa_icon("clipboard") + " Copy"
      end
    end
  end
end
