class CreateMostRecentSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_view :most_recent_submissions
  end
end
