class CreateBets < ActiveRecord::Migration[8.0]
  def change
    create_table :bets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :prediction, null: false

      t.timestamps
    end
  end
end
