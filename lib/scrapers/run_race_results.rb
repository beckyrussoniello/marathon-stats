class RunRaceResults
  include Scraper

  def scrape
    super(true)
  end

  def navigate_to_first_page
    super
    select(event.name, from: 'raceid')
    find('#filter-links').click_link('Overall')
  end

  def set_up_pagination
    self.total_page_count = pagination_table.all('td a').size + 1
  end

  def pagination_table
    all('#race-results-container table')[0]
  end

  def navigate_to_next_page
    next_page_number = page_number + 1
    pagination_table.click_link(next_page_number.to_s)
  end

  def find_data_rows
    self.rows = all('table.arial')[1].all('tr')[row_index..-1]
  end

  def name_cell_index
    1
  end

  def bib_number_cell_index
    3
  end

  def record_performance_stats(performance, cells)
    sex_age = cells[7].text
    performance.age = sex_age.slice(2, 2)
    performance.sex = SEXES[sex_age.slice(0, 1)]
    performance.location = cells[2].text
    performance.net_time = seconds_elapsed(cells[4].text)
    performance.gun_time = seconds_elapsed(cells[9].text)
    performance.average_pace = performance.net_time.to_f / performance.event.distance
  end
end