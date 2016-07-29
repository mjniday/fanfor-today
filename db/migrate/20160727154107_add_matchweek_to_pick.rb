class AddMatchweekToPick < ActiveRecord::Migration[5.0]
  def change
  	add_reference :picks, :matchweek
  end
end
