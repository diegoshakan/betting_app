class AddResultToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :home_team_score, :integer
    add_column :games, :away_team_score, :integer
  end
end
