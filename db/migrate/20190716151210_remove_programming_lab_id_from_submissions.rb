class RemoveProgrammingLabIdFromSubmissions < ActiveRecord::Migration[6.0]
  def change

    remove_column :submissions, :programming_lab_id, :integer
  end
end
