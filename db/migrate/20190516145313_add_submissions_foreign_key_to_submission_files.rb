class AddSubmissionsForeignKeyToSubmissionFiles < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :submission_files, :submissions, on_delete: :cascade
  end
end
