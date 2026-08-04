class RequireAuthorOnSubmissions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :submissions, :author_type, false
    change_column_null :submissions, :author_id, false
  end
end
