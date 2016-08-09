class CreateLeagueUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :league_users do |t|
    	t.column :league_id, :integer
      	t.column :user_id, :integer

      	t.timestamps
    end
  end
end
