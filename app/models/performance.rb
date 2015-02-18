class Performance < ActiveRecord::Base
  belongs_to :runner
  belongs_to :event
  belongs_to :division
  belongs_to :sex

  validates :runner_id, uniqueness: {scope: :race_id}
end
