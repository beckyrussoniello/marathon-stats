class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.references :runner, index: true
      t.string :bib_number
      t.integer :age
      t.string :location
      t.time :net_time
      t.time :gun_time
      t.time :average_pace
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
end
