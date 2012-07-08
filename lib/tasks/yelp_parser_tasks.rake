namespace :yelp do
  namespace :parser do
    desc "Parse Highlights "
    task :highlights => :environment  do
      count = Yelp::Restaurant.where(:highlight_parsed => false).count
      current = 0
      Yelp::Restaurant.where(:highlight_parsed => false).find_each do |r|
        current += 1
        puts "#{r.ylp_uri} - #{current} of #{count}"
        begin
          page = Yelp::Parser::Restaurant.new(r.ylp_uri)
          photos = Yelp::Parser::DishPhotos.new(page.biz_id)
          page.highlights.each do |h|
            highlight_dish = r.highlight_dishes.where(:sentence_review_id => h.data[:sentence_review_id]).first || r.highlight_dishes.new(:sentence_review_id => h.data[:sentence_review_id])

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
          r.highlight_parsed = true
          r.save
        rescue
          puts 'FAILED!'
          #ignored
        end
      end
    end
  end
end