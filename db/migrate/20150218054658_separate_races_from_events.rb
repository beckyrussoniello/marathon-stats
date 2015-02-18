class SeparateRacesFromEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :name
      t.references :race, index: true
      t.decimal :distance, precision: 5, scale: 2
      t.string :results_url
    end

    remove_column :races, :results_url
    rename_column :performances, :race_id, :event_id
  end

  def down
    rename_column :performances, :event_id, :race_id
    add_column :races, :results_url, :string
    drop_table :events
  end
end
