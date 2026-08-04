class AddNorandomp5FlagToProgrammingLab < ActiveRecord::Migration[6.1]
  def change
    add_column :programming_labs, :use_norandom_p5, :boolean, default: false, null: false
  end
end
