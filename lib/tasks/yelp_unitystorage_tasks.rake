require "yajl"
namespace :yelp do
  namespace :unitystorage do
    desc "Puts Restaraunts url to GA UnityStorage for fetch"
    task :puts_restaurant_urls => :environment do
      sent = 0
      count = Yelp::Restaurant.not_in_unitystorage.count

      Yelp::Restaurant.not_in_unitystorage.select("id, ylp_uri").find_in_batches(:batch_size => 500) do |restaurants|
        batch = []
        restaurants.each do |restaurant|
          batch << { :url => 'http://www.yelp.com' + restaurant.ylp_uri, :method => 'get', :params => {} }
        end

        response = Yelp::Parser::UnityStorage.post('/api/raw_content/queue_for_fetch',
                                                   :body => { :batch => Yajl::Encoder.encode(batch),
                                                              :target_queue => 'yelp-fetch-queue' })
        ActiveRecord::Base.transaction do
          digests = response.body.split("\n")
          digests.each_index do |index|
            restaurants[index].update_attribute(:unitystorage_digest, digests[index]);
          end
        end
        sent += restaurants.size
        puts "#{sent} from #{count} is sent!"
      end
    end
  end
end
