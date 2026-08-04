# frozen_string_literal: true

# This policy serves to control access to the IDE.
class IdePolicy < ApplicationPolicy
  def show?
    true
  end

  def send_code?
    true
  end

  def split_pass?
    true
  end
end
