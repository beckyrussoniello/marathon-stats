class Performance < ActiveRecord::Base
  belongs_to :runner
  belongs_to :event
  belongs_to :division
  belongs_to :sex

  validates :runner, presence: true, uniqueness: {scope: :race_id}
  validates :event, presence: true
  validates :bib_number, presence: true
  validates :age, :gun_time, :net_time, :average_pace, numericality: true, allow_nil: true
end
