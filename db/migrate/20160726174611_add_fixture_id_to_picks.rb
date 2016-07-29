class AddFixtureIdToPicks < ActiveRecord::Migration[5.0]
  def change
  	add_reference :picks, :fixture
  end
end
