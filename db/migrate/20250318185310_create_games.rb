# db/migrate/[timestamp]_create_games.rb
class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.references :round, null: false, foreign_key: true
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :away_team, null: false, foreign_key: { to_table: :teams }
      t.timestamps
    end
  end
end
