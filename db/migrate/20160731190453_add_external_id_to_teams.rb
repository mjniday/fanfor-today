class AddExternalIdToTeams < ActiveRecord::Migration[5.0]
  def change
  	add_column :teams, :external_id, :integer
  end
end
