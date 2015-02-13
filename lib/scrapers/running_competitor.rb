class RunningCompetitor
	include Scraper

	attr_accessor :current_sex

	def scrape
		%w(M F).each do |sex_abbrev|
			self.current_sex = sex_abbrev
			navigate_to_results
		#	sleep(2)
			set_up_pagination

			while page_number <= total_page_count
				save_results_from_page
				go_to_next_page
				sleep(2)
			end
		end
	end

	def navigate_to_results
		visit url.sub(/gender\=(M|F)*\&/, "gender=#{current_sex}&")
	end

	def set_up_pagination
		self.page_number = 1
		pagination_info = all('span.pages')[-1].text
		self.total_page_count = pagination_info.match(/ of (\d+)$/)[1].gsub(",", "").to_i
	end

	def save_results_from_page
		self.row_index = 1
		self.rows = all("table.cg-runnergrid-table tr")[row_index..-1]
		
		begin
			rows.each do |row|
				save_performance(row)
				self.row_index = row_index + 1
			end
		rescue Capybara::Poltergeist::ObsoleteNode => e
			puts e.message
			self.rows = all("table.cg-runnergrid-table tr")[row_index..-1]
			self.row_index = 1
			retry
		end
	end

	def go_to_next_page
		unless page_number == total_page_count
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
		self.page_number += 1
	end

	def save_performance(result)
		cells = result.all('td')
		return unless cells.any?

		runner = Runner.find_or_create_by(name: cells[2].text)
		performance = race.performances.find_or_initialize_by(runner: runner, bib_number: cells[1].text)

		# unfortunately, age and gun time are only available on the detail page for each participant.  leaving out for now :-/
		performance.sex = SEXES[current_sex]
		performance.location = cells[3].text
		performance.net_time = seconds_elapsed(cells[4].text)
		performance.average_pace = performance.net_time.to_f / RACE_LENGTH_IN_MILES
		performance.save
	end
end