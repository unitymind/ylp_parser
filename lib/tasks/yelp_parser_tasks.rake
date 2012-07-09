namespace :yelp do
  namespace :parser do
    desc "Parse Highlights "
    task :highlights => :environment do
      Yelp::Parser.proxy = ENV['PROXY'] if ENV['PROXY']
      count = Yelp::Restaurant.where(:highlight_parsed => false).count
      current = 0
      Yelp::Restaurant.where(:highlight_parsed => false).find_each(:start => ENV['START'] || 1, :batch_size => 100) do |restaurant|
        current += 1
        puts "#{restaurant.ylp_uri} - #{current} of #{count}"
        begin
          page = Yelp::Parser::Restaurant.new(restaurant.ylp_uri)
          photos = Yelp::Parser::DishPhotos.new(page.biz_id)
          page.highlights.each do |h|
            highlight_dish = restaurant.highlight_dishes.where(:sentence_review_id => h.data[:sentence_review_id]).first || restaurant.highlight_dishes.new(:sentence_review_id => h.data[:sentence_review_id])

            highlight_dish.biz_id = page.biz_id
            highlight_dish.quote = h.data[:quote]
            highlight_dish.reviews_count = h.data[:reviews_count]

            highlight_dish.dish_name = h.data[:dish_name]
            highlight_dish.dish_photo_url = photos.search(h.data[:dish_name])[0][:url] unless photos.search(h.data[:dish_name]).empty?

            highlight_dish.profile_id = h.profile.profile_id
            highlight_dish.profile_photo_url = h.profile.profile_photo_url
            highlight_dish.profile_name = h.profile.profile_name
            highlight_dish.parsed = true
            puts highlight_dish.inspect
            highlight_dish.save
          end
          restaurant.highlight_parsed = true
          restaurant.save
        rescue Yelp::Parser::Errors::HttpError => ex
          puts "HttpError: #{ex.message}"
          puts "Stop parsing!"
          exit(1)
        rescue Exception => ex
          puts "FAILED!"
          puts ex.inspect
          #raise save
          #ignored
        end
      end
    end

    namespace :highlights do
      desc "Fix highlight_parsed in restaurants"
      task :fix_parsed => :environment do
        Yelp::HighlightDish.select("id, restaraunt_id").group("restaraunt_id").find_each do |h|
          h.restaurant.highlight_parsed = true
          h.restaurant.save
          puts "#{h.restaurant.ylp_uri} fixed!"
        end
      end
    end
  end
end