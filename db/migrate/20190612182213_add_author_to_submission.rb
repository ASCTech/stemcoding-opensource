class AddAuthorToSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :author_type, :string
    add_column :submissions, :author_id, :integer
    add_index :submissions, %i[author_type author_id]
  end
end
