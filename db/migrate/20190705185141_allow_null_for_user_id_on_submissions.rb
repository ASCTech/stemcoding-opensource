class AllowNullForUserIdOnSubmissions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :submissions, :user_id, true
  end
end
