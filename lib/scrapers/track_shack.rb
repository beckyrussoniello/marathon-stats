class TrackShack
	include Scraper

	attr_accessor :divisions

	def navigate_to_first_page
		visit url
		click_button("Search")
	end

	def set_up_pagination
		select_options = all('#select1 option')
		self.divisions = select_options.collect(&:text)
		# need to keep wheelchair separate.  will add back once i flesh out logic re: divisions
		self.divisions = divisions.reject{ |div| div.match(/wheelchair/i) }
		self.total_page_count = divisions.size
	end

	def row_selector
		"tr[class$='_row']"
	end

	def first_row_index
		0
	end

	def navigate_to_next_page
		next_division = divisions[page_number]
		select(next_division, from: "select1")
		click_button("Search")
		self.current_sex = next_division.match(/women/i) ? SEXES['F'] : SEXES['M']
	end

	def name_cell_index
		1
	end

	def bib_number_cell_index
		2
	end

	def record_performance_stats(performance, cells)
		performance.age = cells[3].text
		performance.sex = current_sex
		performance.location = cells[11].text
		performance.net_time = seconds_elapsed(cells[10].text)
		performance.gun_time = seconds_elapsed(cells[9].text)
		performance.average_pace = performance.net_time.to_f / RACE_LENGTH_IN_MILES
	end
end