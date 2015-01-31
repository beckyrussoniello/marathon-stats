class Race < ActiveRecord::Base
	include Capybara::DSL
	Capybara.default_driver = :poltergeist
end
