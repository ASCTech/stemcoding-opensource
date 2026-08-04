# frozen_string_literal: true

# This controller plays the student's code.
class PlayersController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :update_last_active
  skip_after_action :verify_authorized

  layout "player"

  # display the p5 player. If a query param exists, decrypt it and load the
  # render files specified by the ids
  def show
    if params[:query]
      signed_message = params[:query]
      result = verifier.verify(signed_message)
      ids = result[:ids]
      files_text = RenderFile.where(id: ids).pluck(:content).join("\n")

      @use_norandom_p5 = ActiveModel::Type::Boolean.new.cast(result[:use_norandom_p5])
      @custom_script_injection = files_text
      # binding.pry
    else
      redirect_back fallback_location: root_path, flash: { error: "No query provided." }
    end
  end
end
