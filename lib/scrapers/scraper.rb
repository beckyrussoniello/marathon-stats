module Scraper
  include Capybara::DSL
  Capybara.default_driver = :poltergeist
  Capybara.default_wait_time = 5

  UNKNOWN_SEX = Sex.find_by_name('Unknown')
  SEXES = Sex.all.inject(Hash.new(UNKNOWN_SEX)){|hash,sex| hash[sex.abbreviation] = sex; hash}
  SECONDS_IN_AN_HOUR = 3600
  SECONDS_IN_A_MINUTE = 60

  attr_accessor :event, :url, :rows, :row_index, :page_number, :total_page_count, :current_sex

  def initialize(event)
    @event = event
    @url = event.results_url
    @page_number = 1
    @row_index = 1
  end

  def scrape(need_sleep = false)
    navigate_to_first_page
    sleep(2) if need_sleep
    set_up_pagination

    while page_number <= total_page_count
      save_results_from_page
      go_to_next_page
      sleep(2) if need_sleep
    end
  end

  def save_results_from_page
    self.row_index = first_row_index
    
    begin
      find_data_rows
      rows.each do |row|
        save_performance(row)
        self.row_index = row_index + 1
      end
    rescue Capybara::Poltergeist::ObsoleteNode => e
      puts e.message
      retry
    end
  end

  def find_data_rows
    self.rows = all(row_selector)[row_index..-1]
  end

  def save_performance(result)
    cells = result.all('td')
    return unless cells.any?

    runner_name = cells[name_cell_index].text.titleize
    bib_number = cells[bib_number_cell_index].text

    runner = Runner.find_or_create_by(name: runner_name)
    performance = event.performances.find_or_initialize_by(runner: runner, bib_number: bib_number)

    record_performance_stats(performance, cells)
    performance.save
  end

  def go_to_next_page
    unless page_number == total_page_count
      navigate_to_next_page
    end
    self.page_number += 1
  end

  def seconds_elapsed(time_string)
    hours, minutes, seconds = time_string.split(":").collect(&:to_i)
    ((hours * SECONDS_IN_AN_HOUR) + (minutes * SECONDS_IN_A_MINUTE)) + seconds
  end
end