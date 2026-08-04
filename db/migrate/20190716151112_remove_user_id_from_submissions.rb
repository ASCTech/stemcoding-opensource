class RemoveUserIdFromSubmissions < ActiveRecord::Migration[6.0]
  def change
    remove_column :submissions, :user_id, :integer
  end
end
