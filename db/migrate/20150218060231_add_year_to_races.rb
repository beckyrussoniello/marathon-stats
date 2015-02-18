class AddYearToRaces < ActiveRecord::Migration
  def up
    add_column :races, :year, :integer
  end

  def down
    remove_column :races, :year
  end
end
