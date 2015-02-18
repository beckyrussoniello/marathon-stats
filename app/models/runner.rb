class Runner < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true # for now.  
  # Obviously people can have the same name, but until I can
  # reliably tell individuals apart, should probably just have 
  # one record per name.
end
