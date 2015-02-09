class CreatePerformances < ActiveRecord::Migration
  def up
    create_table :performances do |t|
      t.references :runner, index: true
      t.references :race, index: true
      t.string :bib_number
      t.integer :age
      t.string :location
      t.integer :net_time
      t.integer :gun_time
      t.integer :average_pace
      t.references :division, index: true
      t.references :sex, index: true
      t.integer :division_place
      t.integer :sex_place

      t.timestamps null: false
    end
    add_foreign_key :performances, :runners
    add_foreign_key :performances, :divisions
    add_foreign_key :performances, :sexes
  end

  def down
    drop_table :performances
  end
end
