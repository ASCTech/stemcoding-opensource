# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :reorder_by_created_at, ->(dir = :asc) { reorder(created_at: dir) }
  scope :order_by_created_at, ->(dir = :asc) { order(created_at: dir) }

  scope :reorder_by_updated_at, ->(dir = :asc) { reorder(updated_at: dir) }
  scope :order_by_updated_at, ->(dir = :asc) { order(updated_at: dir) }

  scope :created_during, ->(date_range) { where(created_at: date_range) }

  def truncate(string, max)
    string.length > max ? "#{string[0...max]}..." : string
  end
end
