class RenameFixturesMatchweekColumn < ActiveRecord::Migration[5.0]
  def change
  	rename_column :fixtures, :matchweek, :matchweek_id
  end
end
