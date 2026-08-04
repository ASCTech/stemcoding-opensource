class RemoveParentIdFromSubmissions < ActiveRecord::Migration[6.0]
  def change
    remove_column :submissions, :parent_id, :integer
  end
end
