#!/usr/bin/ruby
# @Author: xhb
# @Date:   2016-07-14 23:04:57
# @Last Modified by:   xhb
# @Last Modified time: 2016-07-31 21:56:03

require 'discourse_api'

module DisFetcher
  class DisApi
    
    MY_DOMAIN = "http://www.81kb.com/"
    API_KEY   = "429d092bd30164ff275ecb6f72486d68b5091e600a708fc8679ae0d5edee4077"
    USERNAME  = "xier"
    TOPICS_ID_RECODES = File.expand_path('../../../config/daily_insert_topics.json', __FILE__)

    def initialize()
      @client = DiscourseApi::Client.new(MY_DOMAIN)  
      @client.api_key = API_KEY
      @client.api_username = USERNAME
    end
    
    def post_to_81kb(category, title, content)
      begin
        msg = @client.create_topic(
              category: category,
              skip_validations: true,
              auto_track: false,
              title: "#{title}",
              raw: "#{content}"
            )
        #存好每天post上去的id，过一段时间就删掉
        topic_id = msg["id"]
        write_records(category, topic_id)
      rescue => e 
        p "post_to_81kb:"
        p e.inspect
      end
    end

    def write_records(category, topic_id)
      topics_json = JSON.parse(File.read(TOPICS_ID_RECODES))
      today = Time.now.strftime("%Y%m%d")
      if topics_json.has_key?(today)
        if topics_json[today].has_key?(category)
           topics_json[today][category].push(topic_id)
        else
           topics_json[today][category] = []
           topics_json[today][category].push(topic_id)
        end 
      else
        new_date_json_records = {"#{today}"=>{"#{category}"=>[]}}
        new_date_json_records[today][category].push(topic_id)
        topics_json.merge!(new_date_json_records)
      end
      json_records_str =  JSON.pretty_generate(topics_json)
      File.open(TOPICS_ID_RECODES, "w") do |f|
        f.write(json_records_str)
      end  
    end
   
    def delete_topics_by_date(date)
      topics_json = JSON.parse(File.read(TOPICS_ID_RECODES))
      if topics_json.has_key?(date)
        category = topics_json[date].keys
        category.each do |c|
          topics_json[date][c].each do |id|
            p "delete: #{c} -> #{id}"
            @client.delete_topic(id)
            sleep 5
          end
        end
        topics_json["last_delete_date"] = date
        File.open(TOPICS_ID_RECODES, "w") do |f|
          f.write(JSON.pretty_generate(topics_json))
        end  
      end
    end

    def delete_topics_by_category(category)
      list = @client.topics_by(USERNAME)
      c_array = @client.categories.select { |e| e["name"] == category }
      c_id = c_array.first["id"]
      c_list = list.select{ |e| e["category_id"] == c_id }
      c_list.each do |topic|
        p "delete topic: #{category} -> #{topic['title']}"
        @client.delete_topic(topic["id"]) rescue next
        sleep 5
      end
    end


  end
end

if $0 == __FILE__
  puts File.expand_path('../../../config/daily_insert_topics.json', __FILE__)
  api = DisFetcher::DisApi.new()
  # api.write_records("kangwei", 1213)
  # api.write_records("kangwei", 123)
  # api.write_records("kangwei", 13)
  # api.write_records("你没", 121)
  # api.write_records("你没", 213)
  # api.write_records("你没", 113)
  # today = Time.now.strftime("%Y%m%d")
  # api.delete_topics_by_date(today)
  #api.delete_topics_by_category("看微信")
  #api.delete_topics_by_category("看视频")
  
end
