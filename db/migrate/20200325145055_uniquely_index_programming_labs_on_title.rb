class UniquelyIndexProgrammingLabsOnTitle < ActiveRecord::Migration[6.0]
  def change
    remove_index :programming_labs, :title
    add_index :programming_labs, :title, unique: true
  end
end
