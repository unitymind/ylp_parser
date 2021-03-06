namespace :yelp do
  namespace :parser do
    desc "Parse Highlights "
    task :highlights => :environment do
      Yelp::Parser.proxy = ENV['PROXY'] if ENV['PROXY']
      count = Yelp::Restaurant.where(:highlight_parsed => false).count
      current = 0
      Yelp::Restaurant.highlights_not_parsed.find_each(:start => ENV['START'] || 1, :batch_size => 100) do |restaurant|
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
          puts "Network HttpError: #{ex.message}"
          puts "Stop parsing!"
          exit(1)
        rescue Errno::ETIMEDOUT, Timeout::Error, Errno::ECONNREFUSED, ActiveRecord::RecordNotUnique => ex
          puts "FAILED!"
          puts ex.inspect
        rescue Exception => ex
          puts "FAILED!"
          puts ex.inspect
          raise ex
        end
      end
    end
  end
end