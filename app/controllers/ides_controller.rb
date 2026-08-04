# frozen_string_literal: true

require "render_file_generator"
require "zip"

class IdesController < ApplicationController
  skip_after_action :verify_policy_scoped

  skip_before_action :verify_authenticity_token

  include IdesHelper

  def show
    authorize :ide, :show?
    query = params[:query]

    @files = ide_internal(query).sort_by { |file| file[:filename] }
    @files_text = Base64.encode64(@files.to_json)
  end

  protected

    def default_ide_files
      [{
        filename: "sketch.js",
        content: default_ide_text_sketch,
      }, {
        filename: "functions.js",
        content: default_ide_text_function,
      },]
    end

    def ide_submission(result)
      ids = result[:ids]

      SubmissionFile.where(id: ids).map do |file|
        {
          filename: file[:file],
          content: File.read(file.file.file.path),
        }
      end
    end

    def ide_lab_group(result)
      ids = result[:ids]

      ProgrammingLabFile.where(id: ids).map do |file|
        {
          filename: file[:file],
          content: File.read(file.file.file.path),
        }
      end
    end

    def ide_render(result)
      ids = result[:ids]
      RenderFile.where(id: ids).map do |file|
        {
          filename: file.name,
          content: file.content,
        }
      end
    end

    def ide_code_project(result)
      id = result[:code_project_id]
      @code_project = CodeProject.find(id)

      @code_project.code_project_files.map do |file|
        {
          filename: file.name,
          content: file.content,
        }
      end
    end

    def ide_split_between(result)
      if result[:new_files]
        default_ide_files
      elsif result[:submission]
        ide_submission(result)
      elsif result[:lab_group]
        ide_lab_group(result)
      elsif result[:render]
        ide_render(result)
      elsif result[:code_project]
        ide_code_project(result)
      end
    end

    def ide_internal(query)
      if query.nil?
        default_ide_files
      else
        result = verifier.verify(query)
        @course_lab_id = result[:course_programming_lab_id]
        @use_norandom_p5 = result[:use_norandom_p5]
        ide_split_between(result)
      end
    end
end
