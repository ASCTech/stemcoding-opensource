# frozen_string_literal: true

require "render_file_generator"
require "zip"

# This controller acts as a manager for the vue ide component. It enables the
# functionality of downloading, rendering, and submitting files.
class IdeInternalController < ApplicationController
  skip_before_action :verify_authenticity_token

  # create a code snippet from the file name and code content in the ide & then
  # repsond with that code snippet's record id so can be sent to the player
  def send_code
    authorize :ide, :show?
    name = params[:name]
    hex_data = params[:content]
    strip_data = strip_hex(hex_data)
    raw_data = hex_to_char(strip_data)

    # The regular expression below will allow anything that can be written on a typical
    # keyboard but everything else will be replaced with ''
    #
    # The effect of this is to remove any emojis or uncommon ASCII characters from the
    # student edited code before it goes to be rendered by the browser. This fixes a
    # potential problem where the program is unable to run even if just one emoji
    # or uncommon ASCII character is added to the javascript file, even if that symbol
    # is in a comment.    CMO  9/5/2023

    raw_data = raw_data.gsub(/[^\w\s\d(){}\/;,=<>\[\]!@#$%^&*\|\?.\\\'\":\-\+\~\`]/, '')

    id = RenderFileGenerator.from_data(name, raw_data, current_user)

    render json: { id: id }, status: :created
  end

  # loads the code snippets specified by the ids in the params
  def split_pass
    authorize :ide
    ids_raw = params[:ids]
    ids = RenderFile.where(id: ids_raw.split("-")).where(user: current_user).ids

    if params[:render]
      render_pass(ids)
    elsif params[:download]
      download_pass(ids)
    elsif params[:submit]
      submit_pass(ids)
    elsif params[:save]
      save_pass(ids)
    end
  end

  protected

    def render_pass(ids)
      # Include user_id to verify the correct user is submitting.
      message = { ids: ids, render: true, use_norandom_p5: params[:use_norandom_p5], expires: Time.zone.now + 1.day }
      @signed_message = verifier.generate(message)

      render json: { query: @signed_message }, status: :ok
    end

    # Put the appropriate render files into the zip archive.
    def download_pass_compose(zipfile, ids)
      RenderFile.where(id: ids).each do |file|
        tfile = Tempfile.new(file.name)
        tfile.write(file.content)
        tfile.rewind
        zipfile.add(file.name, tfile.path)
      end
    end

    def download_pass(ids)
      zip_file = Tempfile.new("download.zip")
      Zip::File.open(zip_file.path, Zip::File::CREATE) do |zipfile|
        download_pass_compose(zipfile, ids)
      end
      send_file zip_file.path, filename: "download.zip", disposition: "attachment"
    end

    def submit_pass(ids)
      message = { ids: ids, submit: true, expires: Time.zone.now + 1.day }
      @signed_message = verifier.generate(message)

      render json: { query: @signed_message }
    end

    def save_pass(ids)
      message = { ids: ids, submit: true, expires: Time.zone.now + 1.day }
      @signed_message = verifier.generate(message)

      render json: { query: @signed_message }
    end

    def strip_hex(hex)
      s = ""
      (0..(hex.length / 4 - 1)).each do |i|
        k = i * 4
        s += hex[k + 2]
        s += hex[k + 3]
      end
      s
    end

    def hex_to_char(hex)
      hex.gsub(/../) { |pair| pair.hex.chr }
    end
end
