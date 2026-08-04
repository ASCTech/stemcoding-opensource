class AllowNullForProgrammingLabIdOnSubmissions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :submissions, :programming_lab_id, true
  end
end
