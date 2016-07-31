class AddExternalIdToFixtures < ActiveRecord::Migration[5.0]
  def change
  	add_column :fixtures, :external_id, :integer
  end
end
