class AddPickToLeagues < ActiveRecord::Migration[5.0]
  def change
  	add_reference :picks, :league
  end
end
