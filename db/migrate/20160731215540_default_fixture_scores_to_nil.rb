class DefaultFixtureScoresToNil < ActiveRecord::Migration[5.0]
  def change
  	change_column :fixtures, :home_team_score, :integer, default: nil
  	change_column :fixtures, :away_team_score, :integer, default: nil
  end
end
