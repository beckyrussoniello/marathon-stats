class Sex < ActiveRecord::Base
  validates :name, :abbreviation, presence: true
end
