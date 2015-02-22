class AddResultsProviderToRace < ActiveRecord::Migration
  def up
    add_column :races, :results_provider, :string
  end

  def down
    remove_column :races, :results_provider
  end
end
