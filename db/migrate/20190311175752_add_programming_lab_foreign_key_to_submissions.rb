# frozen_string_literal: true

class AddProgrammingLabForeignKeyToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :submissions, :programming_labs, on_delete: :nullify
  end
end
