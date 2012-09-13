# encoding: utf-8

require "yajl"
namespace :yelp do
  namespace :unitystorage do
    desc "Puts Restaraunts url to GA Unitystorage for fetch"
    task :puts_restaurant_urls => :environment do
      sent = 0
      count = Yelp::Restaurant.not_in_unitystorage.count

      #Yelp::Restaurant.not_in_unitystorage.select("id, ylp_uri").find_in_batches(:batch_size => 500) do |restaurants|
      #  batch = []
      #  restaurants.each do |restaurant|
      #    batch << { :url => 'http://www.yelp.com' + restaurant.ylp_uri, :method => 'get', :params => {} }
      #  end
      #
      #  response = Yelp::Parser::UnityStorage.post('/api/content/fetch',
      #                                             :body => { :batch => Yajl::Encoder.encode(batch),
      #                                                        :target_queue => 'yelp-fetch-queue' })
      #  ActiveRecord::Base.transaction do
      #    digests = response.body.split("\n")
      #    digests.each_index do |index|
      #      restaurants[index].update_attribute(:unitystorage_digest, digests[index]);
      #    end
      #  end
      #  sent += restaurants.size
      #  puts "#{sent} from #{count} is sent!"
      #end

      restaurants = Yelp::Restaurant.select("id, ylp_uri").offset(20000).limit(5).all

      batch = []
      restaurants.each do |restaurant|
        batch << { :url => 'http://www.yelp.com' + restaurant.ylp_uri, :method => 'get', :params => {} }
      end

      response = Yelp::Parser::UnityStorage.post('/api/tasks/push',
                                                 :body => {
                                                    :task_uri => "/tasks/content/fetch",
                                                    :payload => Yajl::Encoder.encode(batch),
                                                    :target_queue => 'yelp-fetch'
                                                 })
      ActiveRecord::Base.transaction do
        digests = response.body.split("\n")
        digests.each_index do |index|
          restaurants[index].update_attribute(:unitystorage_digest, digests[index]);
        end
      end
      sent += restaurants.size
      puts "#{sent} from #{count} is sent!"


    end

    desc "Puts Restaraunts url to GA Unitystorage for fetch"
    task :put_restaurant_urls => :environment do

      dishes = ["Miso Soup",
      "Kinoko Miso Soup",
      "Corn-Miso Porridge",
      "Edamame Soy Beans",
      "Yaki Tako",
      "Kaiso Seaweed Salad",
      "Tuna Tataki Salad",
      "Beet Salad",
      "Hanabi",
      "Yamabuki",
      "Dohyo",
      "Futago",
      "Tontoro",
      "Gyu Carpaccio",
      "Hiya Yakko",
      "Kinoko Dofu",
      "Age Dashi Tofu",
      "Gindara",
      "Burikama",
      "Suzuki",
      "Hotate",
      "Kamo Negi",
      "Hitsuji",
      "Gyu Kakuni",
      "Gyu Filet",
      "Washu Gyu",
      "Shacho's Shabu-Shabu",
"Kinoko",
"Nasu",
"Satsuma Imo",
"Shishito",
"Ikakoromo",
"Tempura Yasai",
"Tempura Ebi",
"Dark Chocolate Fondue",
"Nashi",
"Yuzu Cake",
"Kabocha Cheesecake",
"Rice Pudding",
"Choco Chan",
"Peanut Butter Mousse",
"Seasonal special white otoro (white tuna)",
"Hamachi sashimi",
"Sake",
"Salmon and hamachi sashimi",
"Salmon belly",
"Lobster rolls",
"Black cod",
"Ozumo roll",
"Sake Maborishi",
"Tuna belly sushi"]


      #Yelp::Restaurant.select("id, ylp_uri").where("has_menu = ? AND price >= ?", true, 4).order("review_count DESC").limit(20).each do |restaurant|
        restaurant = Yelp::Restaurant.find(30747)
        puts restaurant.ylp_uri
        response = Yelp::Parser::UnityStorage.put('/api/content/put',
                                                  :body => {
                                                      :target_model => "fm.dish.unitystorage.data.yelp.RestaurantYelp",
                                                      :payload => Yajl::Encoder.encode({ :url => 'http://www.yelp.com/biz/ozumo-san-francisco', # + restaurant.ylp_uri,
                                                                                         :method => 'get', :params => {},
                                                                                         :dishes => dishes.map { |d| {:name => d, :normalized_name => d} } })
                                                                                         #:dishes => restaurant.dishes.map { |d| {:name => d.name, :normalized_name => d.normalized_name} } })
                                                                                         #:restaurant_id => Restaurant.select('id').where(:yelp_restaurant_id => restaurant.id).first.id } ),
                                                  })
      #
      #response = Yelp::Parser::UnityStorage.put('/api/content/put',
      #                                          :body => {
      #                                              :target_model => "fm.dish.unitystorage.data.yelp.ProfileYelp",
      #                                              :payload => Yajl::Encoder.encode({ :url => 'http://www.yelp.com/user_details', :method => 'get', :params => { "userid" => "QSWJtxLoVriPLjVyP1Qt3Q"} }),
      #                                          })

        puts response.inspect
      #end


    end

    desc "Puts no menu Restaraunts url to GA Unitystorage for fetch and parsing"
    task :put_no_menu_restaurant_urls => :environment do
      def get_dishes_for_category(cat_name, size)
        result = []
        ActiveRecord::Base.connection.execute("SELECT DISTINCT(dishes.normalized_name), dishes.name, COUNT(dishes.normalized_name) as dish_count
FROM yelp_dishes AS dishes, yelp_restaurants AS restaurants
WHERE dishes.ylp_restaurant_id = restaurants.id AND dishes.normalized_name != '' AND restaurants.category LIKE '%#{cat_name}%'
GROUP BY dishes.normalized_name
ORDER BY dish_count DESC
LIMIT #{500/size}").each do |dish|
          if dish[2] >= 3
            result << {:name => dish[1], :normalized_name => dish[0] }
          end
        end
        result
      end

#      Yelp::Restaurant.find_by_sql("SELECT DISTINCT(yelp_restaurants.category), yelp_restaurants.id, yelp_restaurants.ylp_uri
#FROM yelp_restaurants, restaurants
#WHERE restaurants.yelp_restaurant_id = yelp_restaurants.id AND yelp_restaurants.has_menu = false
#GROUP BY yelp_restaurants.category
#ORDER BY yelp_restaurants.review_count DESC, yelp_restaurants.category
#LIMIT 1, 100").each do |restaurant|
      i = 742
      Yelp::Restaurant.where(:city => 'San Francisco').order('review_count DESC').offset(i).limit(1000 - i).each do |restaurant|
        dishes = []
        if restaurant.has_menu
          dishes = restaurant.dishes.map { |d| {:name => d.name, :normalized_name => d.normalized_name} }
        else
          сategories = restaurant.category.split(',')
          сategories.each do |category|
            dishes << get_dishes_for_category(category, сategories.size)
          end
          dishes.flatten!
        end

        response = Yelp::Parser::UnityStorage.put('/api/content/put',
                                                  :body => {
                                                    :target_model => "fm.dish.unitystorage.data.yelp.RestaurantYelp",
                                                    :payload => Yajl::Encoder.encode({ :url => 'http://www.yelp.com' + restaurant.ylp_uri,
                                                                                         :method => 'get', :params => {},

                                                                                         :dishes => dishes} ) })
        puts response.inspect
        puts i
        i += 1
      end


    end

    desc "Puts proxy list for using"
    task :puts_proxy => :environment do
      proxy_list =
          %w(
122.141.242.134:80
101.44.1.23:80
124.207.162.190:80
122.72.112.136:80
122.72.80.99:80
171.98.92.15:3128
122.72.36.80:80
218.247.129.7:80
211.167.112.16:82
122.72.28.12:80
211.161.152.107:80
202.51.121.86:3128
122.141.242.135:80
122.72.80.46:80
65.111.164.53:3128
190.248.130.210:3128
193.89.116.106:443
200.57.26.62:8080
177.85.233.200:8088
188.165.215.175:3128
95.211.46.111:3128
187.73.240.103:3128
79.120.177.37:8080
177.69.31.147:80
84.41.108.74:8080
109.205.117.155:8080
41.73.2.35:8080
200.5.253.139:3128
192.162.150.77:3128
189.8.69.42:80
88.85.125.78:8080
121.15.167.231:8080
91.144.44.65:3128
190.96.64.234:8080
94.75.234.136:3128
183.89.43.75:3128
186.250.1.18:8080
72.64.146.136:3128
187.87.231.102:80
94.249.175.171:3128
62.201.214.52:8080
201.39.143.158:8080
41.237.230.121:8080
114.215.51.13:80
59.37.163.156:3128
60.185.109.86:6666
177.43.39.27:3128
201.251.62.137:8080
189.72.230.72:80
201.45.252.99:3128
202.142.17.120:80
60.190.129.52:3128
178.77.136.76:80
122.152.53.170:8080
60.10.58.38:8090
211.115.185.58:80
211.154.83.35:82
120.43.28.133:6675
219.141.65.242:6666
58.218.174.154:1337
61.55.141.12:80
61.52.51.156:6666
115.124.66.205:80
186.92.248.251:8080
186.114.157.83:8085
200.105.245.237:3129
196.215.167.10:8080
123.165.89.97:6675
182.52.86.170:3128
201.39.237.170:3128
183.95.132.76:80
201.74.228.218:3128
119.186.160.86:8000
116.212.112.247:8888
221.11.6.166:8080
218.108.168.138:80
196.215.167.10:8080
182.52.86.170:3128
123.165.89.97:6675
183.95.132.76:80
201.74.228.218:3128
119.186.160.86:8000
116.212.112.247:8888
221.11.6.166:8080
218.108.168.138:80
218.108.168.165:82
60.28.245.251:80
218.108.168.136:80
60.211.28.139:6675
202.137.19.3:8080
223.5.16.143:80
124.132.203.167:6666
41.32.163.173:8080
112.94.146.31:8080
116.90.230.222:3128
49.116.255.13:6675
50.7.10.34:8080
61.8.77.74:3128
190.77.133.94:8080
189.25.133.150:8080
190.74.181.178:8080
180.242.91.195:8080
200.114.103.213:8080
189.104.87.6:8080
119.82.252.140:80
218.94.1.166:82
189.76.81.250:8080
211.167.72.130:8909
180.241.250.105:3128
201.75.69.85:80
118.96.251.234:8080
70.182.114.1:8080
58.222.141.120:3128
218.108.242.124:80
113.137.140.149:8909
178.21.113.238:3128
196.45.51.27:8080
118.96.153.181:8080
124.207.162.118:80
164.77.195.20:3128
58.215.170.154:3128
119.97.146.148:80
180.245.246.239:8080
213.189.34.150:80
118.96.194.228:8080
124.195.6.243:8080
119.252.160.34:8080
118.97.16.106:8080
46.17.63.196:3128
79.101.37.138:8080
190.145.55.171:3128
116.254.100.86:8080
173.224.218.230:8080
)
      puts proxy_list.inspect

      batch = []
      proxy_list.each { |proxy| batch << {:proxy => proxy}}
      #proxy_list.shuffle[0..9].each { |proxy| batch << {:proxy => proxy}}

      response = Yelp::Parser::UnityStorage.post('/api/tasks', :body => {
          :task_uri => "/tasks/proxy/check",
          :payload => Yajl::Encoder.encode(batch),
          :target_queue => 'proxy-check' })

      puts response.inspect

    end
  end

  desc "Puts proxy list for using"
  task :remove_duplicates => :environment do

    offset = 0

    while (true)
      response = Yelp::Parser::UnityStorage.get('/admin/blobs/remove', :query => {
          :limit => 50,
          :offset => offset })

      puts response.inspect

      offset += 50
    end

  end

  desc "Remove blobs"
  task :remove_blobs => :environment do

    while (true)
      begin
        response = Yelp::Parser::UnityStorage.get('/admin/blobs/remove')

        puts response.inspect
      rescue Timeout::Error
        puts "Timeout"
      end
    end

  end

  desc "Normalize dish names"
  task :normalize_dishes => :environment do
    #order("normalized_name DESC").limit(1000).each do |dish|

    puts "==================>>>>>"
    puts ""

    Yelp::Dish.find_each do |dish| # order("name ASC").limit(200).offset(11800).each do |dish| #.offset(100).limit(50).each do |dish| #where(:normalized_name => nil).find_each do |dish| where("LOWER(name) LIKE '%oz%'")
      dish.normalized_name = Yajl::Encoder.encode(Yelp::Dish.normalize(dish.name.dup))

      if dish.normalized_name == '[]'
        puts "to delete #{dish.normalized_name}"
        dish.destroy
      else
        puts "#{dish.name} -> #{dish.normalized_name}"
        dish.save
      end
    end
  end
end
