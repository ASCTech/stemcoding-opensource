class AddCreatorForeignKeyToCourses < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :courses, :users, column: :creator_id
  end
end
