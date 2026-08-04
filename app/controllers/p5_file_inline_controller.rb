# frozen_string_literal: true

# Allows inline access to a p5.js source file
class P5FileInlineController < ApplicationController
  # see:
  # https://api.rubyonrails.org/v5.2/classes/ActionController/RequestForgeryProtection.html
  skip_before_action :verify_authenticity_token

  # TODO: Make this a little less hacky... But wait till Dr. Orban goes for it!
  # UPDATE: Sep16 2016, We have decided to go with the p5js version, currently
  # this is not being a major issue as it is mostly behind the scenes and no one
  # will see this unless they go digging through the html and javascript code,
  # that I will leave it as is for the time being. (Although there could potentially
  # be some security vulnerabilities, it does go through pundit so I hope that
  # will be sufficient for the time being.)
  def show
    @file = is_submission? ? SubmissionFile.find(resource_id) : ProgrammingLabFile.find(resource_id)

    authorize @file

    send_file(
      @file.file.path,
      filename: @file.file.filename,
      type: "text/javascript",
      disposition: :inline
    )
  end

  private

    def is_submission?
      params.permit(:submission)[:submission]
    end

    def resource_id
      params.require(:id)
    end
end
