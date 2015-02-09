module Scraper
	include Capybara::DSL
	Capybara.default_driver = :poltergeist
	Capybara.default_wait_time = 5

	UNKNOWN_SEX = Sex.find_by_name('Unknown')
	SEXES = Sex.all.inject(Hash.new(UNKNOWN_SEX)){|hash,sex| hash[sex.abbreviation] = sex; hash}
	SECONDS_IN_AN_HOUR = 3600
	SECONDS_IN_A_MINUTE = 60



	def seconds_elapsed(time_string)
		hours, minutes, seconds = time_string.split(":").collect(&:to_i)
		((hours * SECONDS_IN_AN_HOUR) + (minutes * SECONDS_IN_A_MINUTE)) + seconds
	end
end