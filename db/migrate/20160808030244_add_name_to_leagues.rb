class AddNameToLeagues < ActiveRecord::Migration[5.0]
  def change
  	add_column :leagues, :name, :string
  end
end
