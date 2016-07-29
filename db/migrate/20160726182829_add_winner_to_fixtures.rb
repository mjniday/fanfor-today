class AddWinnerToFixtures < ActiveRecord::Migration[5.0]
  def change
  	add_column :fixtures, :winner_id, :integer
  end
end
