#!/usr/bin/ruby
# @Author: xhb
# @Date:   2016-07-14 23:04:57
# @Last Modified by:   xhb
# @Last Modified time: 2016-07-18 23:41:04

require 'discourse_api'

module DisFetcher
  class DisApi
    
    MY_DOMAIN = "http://www.81kb.com/"
    API_KEY   = "429d092bd30164ff275ecb6f72486d68b5091e600a708fc8679ae0d5edee4077"
    USERNAME  = "xier"


    def initialize()
      @client = DiscourseApi::Client.new(MY_DOMAIN)  
      @client.api_key = API_KEY
      @client.api_username = USERNAME
    end
    
    def post_to_81kb(category, title, content)
      msg = @client.create_topic(
              category: category,
              skip_validations: true,
              auto_track: false,
              title: "#{title}",
              raw: "#{content}"
            )
      #存好每天post上去的id，过一段时间就删掉
      id = msg["id"]
    end

    def delete_topic_by_date(date)
      id_json = JSON.parse(File.read(id_file))
      id_json["ids"].each do |id| 
        @client.delete_topic(id)  
        qiniu_topic_resourse_clean(id)
      end
    end


  end
end
