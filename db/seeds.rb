# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Sex.create([{name: 'Female', abbreviation: 'F'}, {name: 'Male', abbreviation: 'M'}, {name: 'Unknown', abbreviation: 'U'}])

races = Race.create(
  [
    {
      name: 'OneAmerica 500 Festival Mini-Marathon & Finish Line Festival 5K', 
      year: 2014, 
      date: Date.new(2014, 5, 1), 
      location: 'Indianapolis, IN',
      website: 'http://www.500festival.com/', 
      results_provider: 'Xacte',
      events_attributes: [
        {
          name: 'MINI', 
          distance: 13.1, 
          results_url: 'http://results.xacte.com/?kw=indy'
        }
      ]
    },
    {
      name: "Rock 'n' Roll Las Vegas Marathon & Half Marathon", 
      year: 2014, 
      date: Date.new(2014, 8, 31), 
      location: 'Las Vegas, NV', 
      website: 'http://runrocknroll.competitor.com/las-vegas/', 
      results_provider: 'RunningCompetitor',
      events_attributes: [
        {
          name: 'Half Marathon', 
          distance: 13.1, 
          results_url: 'http://running.competitor.com/cgiresults?eId=2&eiId=214&seId=697&resultsPage=1&rowCount=100&firstname=&lastname=&bib=&gender=M&division=&city=&state=&submit='
        }
      ]
    },
    {
      name: 'Walt Disney World Marathon Weekend', 
      year: 2014, 
      date: Date.new(2014, 1, 11), 
      location: 'Lake Buena Vista, FL', 
      website: 'http://www.rundisney.com/disneyworld-marathon/', 
      results_provider: 'TrackShack',
      events_attributes: [
        {
          name: 'Half Marathon', 
          distance: 13.1, 
          results_url: 'http://trackshack.com/disneysports/results/wdw/wdw14/hm_results.php'
        }
      ]
    },
    {
      name: 'Lifetime Miami Marathon And Half Marathon', 
      year: 2014, 
      date: Date.new(2014, 1, 24), 
      location: 'Miami, FL', 
      website: 'http://www.themiamimarathon.com/', 
      results_provider: 'Xacte',
      events_attributes: [
        {
          name: 'Half', 
          distance: 13.1, 
          results_url: 'http://live.xacte.com/lifetimemiami/'
        }
      ]
    }
  ]
)