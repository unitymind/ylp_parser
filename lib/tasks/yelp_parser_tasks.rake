namespace :yelp do
  namespace :parser do
    desc "test"
    task :highlights => :environment  do
      r = Yelp::Restaurant.first
      page = Yelp::Parser::Restaurant.parse(r.ylp_uri)
      page.highlights.each do |h|
        puts h.profile.class
      end
      #puts page.parsed_response.class
      #puts page.response.inspect
      #puts page.headers.inspect
    end
  end
end