class CreateRoundWinners < ActiveRecord::Migration[8.0]
  def change
    create_table :round_winners do |t|
      t.references :round, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
