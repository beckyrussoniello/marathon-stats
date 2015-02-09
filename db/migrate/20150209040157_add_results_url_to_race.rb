class AddResultsUrlToRace < ActiveRecord::Migration
  def up
    add_column :races, :results_url, :string
  end

  def down
  	remove_column :races, :results_url
  end
end
