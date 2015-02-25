class Event < ActiveRecord::Base
  belongs_to :race
  has_many :performances

  validates :name, presence: true, uniqueness: { scope: :race_id }
  validates :distance, presence: true, inclusion: { in: SUPPORTED_DISTANCES }
  validates :results_url, presence: true, format: { with: URI.regexp }

  def populate_results_data
    scraper_class = eval race.results_provider
    scraper = scraper_class.new(self)
    scraper.scrape
  end
end