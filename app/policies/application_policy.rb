# frozen_string_literal: true

require "forwardable"

class ApplicationPolicy
  extend Forwardable

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    extend Forwardable

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    protected

      def_delegators :user,
        :admin?,
        :super_teacher?,
        :teacher?,
        :student?
  end

  protected

    def_delegators :user,
      :admin?,
      :super_teacher?,
      :teacher?,
      :student?
end
