class TrackShack
	include Scraper

	attr_accessor :divisions, :current_sex

	def scrape
		navigate_to_results
		set_up_pagination

		while page_number <= total_page_count
			save_results_from_page
			go_to_next_page
		end
	end

	def navigate_to_results
		visit url
		click_button("Search")
	end

	def set_up_pagination
		select_options = all('#select1 option')
		self.divisions = select_options.collect(&:text)
		# need to keep wheelchair separate.  will add back once i flesh out logic re: divisions
		self.divisions = divisions.reject{ |div| div.match(/wheelchair/i) }
		self.total_page_count = divisions.size
		self.page_number = 1
	end

	def save_results_from_page
		self.row_index = 0
		self.rows = all("tr[class$='_row']")
		
		begin
			rows.each do |row|
				save_performance(row)
				self.row_index = row_index + 1
			end
		rescue Capybara::Poltergeist::ObsoleteNode => e
			puts e.message
			self.rows = all("tr[class$='_row']")
			self.row_index = 0
			retry
		end
	end

	def go_to_next_page
		unless page_number == total_page_count
			next_division = divisions[page_number]
			select(next_division, from: "select1")
			click_button("Search")
			self.current_sex = next_division.match(/women/i) ? SEXES['F'] : SEXES['M']
		end
		self.page_number += 1
	end

	def save_performance(result)
		cells = result.all('td')
		return unless cells.any?

		runner = Runner.find_or_create_by(name: cells[1].text.titleize)
		performance = race.performances.find_or_initialize_by(runner: runner, bib_number: cells[2].text)

		performance.age = cells[3].text
		performance.sex = current_sex
		performance.location = cells[11].text
		performance.net_time = seconds_elapsed(cells[10].text)
		performance.gun_time = seconds_elapsed(cells[9].text)
		performance.average_pace = performance.net_time.to_f / RACE_LENGTH_IN_MILES
		performance.save
	end
end