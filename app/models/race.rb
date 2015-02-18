class Race < ActiveRecord::Base
  has_many :events

  validates :name, presence: true, uniqueness: { scope: :year } 
  validates :date, :location, presence: true
  validates :year, presence: true, inclusion: { in: [1990..Date.today.year]}
  validate :date_and_year_match

  def date_and_year_match
    unless date.year == year
      errors.add(:date, "Must match year")
    end
  end
end
