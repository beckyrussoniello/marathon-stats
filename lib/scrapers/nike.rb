class Nike
  include Scraper

  attr_accessor :there_are_more_results

  def initialize(event)
    @there_are_more_results = true
    super
  end

  def scrape(need_sleep = false)
    navigate_to_first_page
    
    while there_are_more_results
      save_results_from_page
      navigate_to_next_page
    end
  end

  def navigate_to_next_page
    all('div.pagination')[0].click_button("Next")
  rescue Capybara::ElementNotFound
    there_are_more_results = false
  end

  def row_selector
    'tr.ng-scope'
  end

  def first_row_index
    0
  end

  def name_cell_index
    3
  end

  def bib_number_cell_index
    2
  end

  def runner_location
    cells[5].text + ', ' + cells[6].text
  end

  def record_performance_stats(performance, cells)
    performance.age = cells[4].text
    division = cells[7].text.gsub("OV_F_", "")
    performance.sex = SEXES[division[0]]
    performance.location = runner_location
    performance.net_time = seconds_elapsed(cells[13].text)
    performance.average_pace = seconds_elapsed(cells[14].text)
  end
end