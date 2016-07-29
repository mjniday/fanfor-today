class AddMatchweekToFixtures < ActiveRecord::Migration[5.0]
  def change
  	add_column :fixtures, :matchweek, :integer
  end
end
