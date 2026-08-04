# frozen_string_literal: true

require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  self.responder = ApplicationResponder

  respond_to :html, :js

  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  before_action :update_last_active

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

    def verifier
      @verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.credentials.secret_key_base)
    end

  private

    def update_last_active
      current_user&.update(last_active_at: Time.zone.now)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
    redirect_back_or_to(root_path)
  end
end
