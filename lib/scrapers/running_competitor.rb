class RunningCompetitor
	include Scraper

	def scrape
		%w(M F).each do |sex_abbrev|
			self.current_sex = sex_abbrev
			super
		end
	end

	def navigate_to_first_page
		visit url.sub(/gender\=(M|F)*\&/, "gender=#{current_sex}&")
	end

	def set_up_pagination
		pagination_info = all('span.pages')[-1].text
		self.total_page_count = pagination_info.match(/ of (\d+)$/)[1].gsub(",", "").to_i
	end

	def row_selector
		"table.cg-runnergrid-table tr"
	end

	def first_row_index
		1
	end

	def navigate_to_next_page
		tries = 0
		begin
			all('a.page')[-1].click
		rescue Capybara::Poltergeist::JavascriptError => e
			if tries < 3
				retry
			else
				raise
			end
		ensure
			tries += 1
		end
	end

	def name_cell_index
		2
	end

	def bib_number_cell_index
		1
	end

	def record_performance_stats(performance, cells)
		# unfortunately, age and gun time are only available on the detail page for each participant.  leaving out for now :-/
		performance.sex = SEXES[current_sex]
		performance.location = cells[3].text
		performance.net_time = seconds_elapsed(cells[4].text)
		performance.average_pace = performance.net_time.to_f / RACE_LENGTH_IN_MILES
	end
end