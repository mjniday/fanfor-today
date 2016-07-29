class CreatePicks < ActiveRecord::Migration[5.0]
  def change
  	create_table :teams do |t|
  	  t.string :name

      t.timestamps
    end

  	create_table :fixtures do |t|
  	  t.integer :home_team_id
	  t.integer :home_team_score
	  t.integer :away_team_id
	  t.integer :away_team_score

      t.timestamps
    end

    create_table :picks do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.integer    :result_points
	  t.integer    :result_gd

      t.timestamps
    end
  end
end
