class Xacte
	include Scraper

	def scrape
		navigate_to_results
		sleep(2)
		set_up_pagination

		while page_number <= total_page_count
			save_results_from_page
			go_to_next_page
			sleep(2)
		end
	end

	def navigate_to_results
		visit url
		click_link("Placings")
		select("Half", from: "xact_results_agegroup_race")
		select("100", from: "xact_results_agegroup_results_length")
	end

	def set_up_pagination
		self.page_number = 1
		pagination_info = find("#xact_results_agegroup_results_info").text
		total_num_entries = pagination_info.match(/of ([\d\,]+) entries/)[1].gsub(",", "").to_f
		self.total_page_count = (total_num_entries / 100).ceil
	end

	def go_to_next_page
		unless page_number == total_page_count
			find("#xact_results_agegroup_results_paginate a.next").click 
		end
		self.page_number += 1
	end

	def save_results_from_page
		self.rows = all("table#xact_results_agegroup_results tr")
		self.row_index = 1
		
		begin
			rows.each do |row|
				save_performance(row)
				self.row_index = row_index + 1
			end
		rescue Capybara::Poltergeist::ObsoleteNode => e
			puts e.message
			self.rows = all("table#xact_results_agegroup_results tr")[row_index..-1]
			self.row_index = 1
			retry
		end
	end

	def save_performance(result)
		cells = result.all('td')
		return unless cells.any?

		runner = Runner.find_or_create_by(name: cells[2].text)
		performance = race.performances.find_or_initialize_by(runner: runner, bib_number: cells[1].text)

		age_sex = cells[4].text
		performance.age = age_sex.match(/\d+/)[0]
		sex_abbrev = age_sex.match(/[A-Z]/)[0] rescue nil
		performance.sex = SEXES[sex_abbrev]
		performance.location = cells[3].text
		performance.net_time = seconds_elapsed(cells[5].text)
		performance.gun_time = seconds_elapsed(cells[6].text)
		performance.average_pace = seconds_elapsed("00:" + cells[7].text.gsub("/mi", ""))
		performance.save
	end
end