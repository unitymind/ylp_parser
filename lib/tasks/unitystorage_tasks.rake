require "yajl"

namespace :unitystorage do
  desc "Fetch mail template"
  task :fetch_mail_template do

    batch = []
    batch << { :url => 'http://demo.disherence.com/letter.html', :method => 'get', :params => {} }


    response = Yelp::Parser::UnityStorage.post('/api/tasks/push',
                                               :body => {
                                                  :task_uri => "/tasks/content/fetch",
                                                  :payload => Yajl::Encoder.encode(batch),
                                                  :target_queue => 'fetch'
                                               })

    puts response.inspect
  end

  desc "Send emails"
  task :send_emails do

    batch = []
    file = File.open(File.join(Rails.root, 'email_list.txt'), 'r')
    emails = file.readlines()
    file.close()

    emails.each do | email|
      if batch.size >= 500
        response = Yelp::Parser::UnityStorage.post('/api/tasks/push',
                                                   :body => {
                                                       :task_uri => "/tasks/mail/send",
                                                       :payload => Yajl::Encoder.encode(batch),
                                                       :target_queue => 'mail-send'
                                                   })

        puts response.inspect
        batch.clear
      end
      batch << { :target_email => email.strip }
    end

    if batch.size > 0
      response = Yelp::Parser::UnityStorage.post('/api/tasks/push',
                                                 :body => {
                                                     :task_uri => "/tasks/mail/send",
                                                     :payload => Yajl::Encoder.encode(batch),
                                                     :target_queue => 'mail-send'
                                                 })

      puts response.inspect
    end
  end

  #1b19a0fc74fffd5243adeded89f8f6e34921f27a0ddb93dd91cfd63eb98
end
