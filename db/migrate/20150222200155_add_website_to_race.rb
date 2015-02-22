class AddWebsiteToRace < ActiveRecord::Migration
  def up
    add_column :races, :website, :string
  end

  def down
    remove_column :races, :website
  end
end
