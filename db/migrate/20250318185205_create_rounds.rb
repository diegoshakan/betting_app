class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.integer :number, null: false

      t.timestamps
    end
  end
end
