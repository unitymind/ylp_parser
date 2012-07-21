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

      restaurants = Yelp::Restaurant.select("id, ylp_uri").offset(16000).limit(100).all

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

    desc "Puts proxy list for using"
    task :puts_proxy => :environment do
      proxy_list =
          %w(
58.248.217.215:80
211.161.152.108:80
202.194.177.20:3128
88.198.24.108:3128
202.116.161.11:808
209.239.113.226:3128
41.42.137.37:8080
190.202.87.134:3128
190.85.151.90:8080
190.147.168.130:8080
186.3.40.110:8080
218.206.228.222:3128
80.149.236.149:80
190.85.55.187:8080
187.115.2.12:8080
91.144.44.65:8080
91.200.114.27:8080
190.214.5.18:8080
46.175.86.15:80
190.249.172.230:8080
177.65.66.143:8080
213.131.41.98:8080
200.96.185.228:3128
201.73.70.40:3128
91.144.44.86:8080
203.77.186.186:80
201.90.8.34:3128
118.97.185.126:8080
27.131.188.106:8080
122.200.147.211:8080
201.12.116.18:80
203.142.72.118:8080
119.205.216.216:80
109.86.203.184:54321
118.220.172.89:80
61.155.107.247:808
82.211.191.68:8080
41.43.31.152:8080
222.60.8.66:80
219.130.163.201:8909
221.176.14.72:80
41.35.48.10:8080
119.252.160.34:8000
203.20.238.21:80
41.73.2.36:8080
60.190.5.36:8909
124.226.53.22:6666
222.241.120.89:6666
61.55.141.12:80
116.68.255.234:8080
110.136.159.41:8080
121.22.88.67:80
60.161.66.28:6666
113.134.164.105:6675
203.142.72.150:8080
221.225.255.22:6675
202.142.17.120:80
119.122.29.26:6675
187.65.82.217:8080
118.96.105.143:8080
202.43.183.202:3128
221.2.174.164:8082
121.56.183.181:6675
189.3.21.70:3128
211.154.83.40:82
200.42.116.164:8080
121.227.180.36:6666
124.236.211.219:6675
189.31.178.64:8080
218.29.131.11:3128
92.241.65.46:8080
123.234.31.130:8090
61.188.220.196:6675
61.182.216.25:8090
118.96.251.234:8080
218.89.110.204:6675
113.201.163.116:8909
124.195.200.51:8080
123.125.50.78:80
61.135.208.184:80
112.125.42.20:10080
222.131.215.46:6666
190.186.198.210:80
91.121.102.62:3128
211.162.32.40:81
187.20.120.92:8080
41.32.126.166:8080
123.159.245.79:6675
180.242.249.255:8080
201.10.55.3:8080
222.130.23.177:6675
67.205.96.72:54321
180.183.154.243:3128
112.84.166.217:6675
60.12.193.45:8090
67.205.100.86:54321
60.188.81.197:6675
177.64.155.216:8080
46.252.32.205:8080
110.74.222.121:8080
196.28.57.64:80
187.15.39.128:8080
218.76.157.98:8001
117.239.12.115:3128
219.83.71.250:8080
201.33.29.20:8080
203.170.192.244:3128
190.213.73.105:8080
119.235.16.41:8080
82.160.19.94:8080
190.42.242.142:8080
189.104.208.161:8080
201.208.108.177:3128
220.179.112.218:6666
115.248.206.187:8080
118.79.41.15:6675
118.174.133.14:3128
118.175.4.82:3128
59.172.208.186:8080
180.246.183.72:3128
115.61.144.142:6666
202.164.217.21:8080
220.181.72.199:80
118.96.78.13:8080
61.163.107.58:8000
190.199.226.64:8080
187.72.145.54:8080
112.94.186.35:8080
190.77.16.49:8080
189.10.161.82:3128
58.67.147.205:8080
202.117.55.122:8888
186.91.161.148:8080
)
      puts proxy_list.inspect

      batch = []
      proxy_list.each { |proxy| batch << {:proxy => proxy}}

      response = Yelp::Parser::UnityStorage.post('/api/tasks/push', :body => {
          :task_uri => "/tasks/proxy/check",
          :payload => Yajl::Encoder.encode(batch),
          :target_queue => 'proxy-check'})

      puts response.inspect

    end
  end
end
