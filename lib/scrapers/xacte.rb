class Xacte
	include Scraper

	def scrape
		super(true)
	end

	def navigate_to_first_page
		visit url
		click_link("Placings")
		select("Half", from: "xact_results_agegroup_race")
		select("100", from: "xact_results_agegroup_results_length")
	end

	def set_up_pagination
		pagination_info = find("#xact_results_agegroup_results_info").text
		total_num_entries = pagination_info.match(/of ([\d\,]+) entries/)[1].gsub(",", "").to_f
		self.total_page_count = (total_num_entries / 100).ceil
	end

	def navigate_to_next_page
		find("#xact_results_agegroup_results_paginate a.next").click 
	end

	def row_selector
		"table#xact_results_agegroup_results tr"
	end

	def first_row_index
		1
	end

	def name_cell_index
		2
	end

	def bib_number_cell_index
		1
	end

	def record_performance_stats(performance, cells)
		age_sex = cells[4].text
		performance.age = age_sex.match(/\d+/)[0]
		sex_abbrev = age_sex.match(/[A-Z]/)[0] rescue nil
		performance.sex = SEXES[sex_abbrev]
		performance.location = cells[3].text
		performance.net_time = seconds_elapsed(cells[5].text)
		performance.gun_time = seconds_elapsed(cells[6].text)
		performance.average_pace = seconds_elapsed("00:" + cells[7].text.gsub("/mi", ""))
	end
end