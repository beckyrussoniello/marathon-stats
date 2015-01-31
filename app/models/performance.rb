class Performance < ActiveRecord::Base
  belongs_to :runner
  belongs_to :division
  belongs_to :sex
end
