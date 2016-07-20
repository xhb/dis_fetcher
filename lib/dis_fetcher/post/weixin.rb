#!/usr/bin/ruby
# @Author: xhb
# @Date:   2016-07-08 22:24:43
# @Last Modified by:   xhb
# @Last Modified time: 2016-07-18 23:41:28

# 1.功能：把传送门上面的微信文章收集起来，然后自动更新到81kb上面去
# 2.接口：
#        - fetch
#        - insert
#        - run

require 'nokogiri'
require 'open-uri'
require 'faraday'
require 'reverse_markdown'
require 'stringio'

module DisFetcher
  module Post
    
    class Weixin
      
      #原始微信的图片地址
      QQ_WEIXIN_PIC_PATH = 'http://read.html5.qq.com/image?src=forum&q=5&r=0&imgflag=7&imageUrl=http://mmbiz.qpic.cn/'
      #我的微信七牛加速地址
      WEICDN_PATH = 'http://weicdn.81kb.com/'

      #传送门最热微信地址
      PASSPORT_GATE_URL = "http://werank.cn/"
      #81kb apikey
      API_KEY_FOR_81KB = "429d092bd30164ff275ecb6f72486d68b5091e600a708fc8679ae0d5edee4077"
      #81kb username
      USER_NAME_FOR_81KB = "xier"
      
      POST_HEADER = "浏览量：%s &nbsp; 点赞量: %s &nbsp; 来源: %s &nbsp;"

      WEIXIN_CATEGORY = "看微信"
 
      def initialize
        @api = DisFetcher::DisApi.new
        @post_url_array = []
      end
      
      # 获取传送门的微信数据
      # url 数据格式
      #[
      #  [ 
      #    ["任真天", "http://chuansong.me/account/rzt317"], 
      #    ["最近吃太胖飞不动，这种感觉也挺好的", "http://chuansong.me/n/409580851451"], 
      #    "第3条", 
      #    "10万+", 
      #    "1473", 
      #    "49", 
      #    "-"
      #  ]
      #]
      def fetch_urls
        page = Nokogiri::HTML(open(PASSPORT_GATE_URL))
        all_post_table = page.css("body > div.container > div:nth-child(8) > div > table > tbody")
        all_post_table.css("tr").each do | line |
          one_post_data = []
          line.css("td").each do | prop |
            link = prop.css("a")
            if not link.empty? 
               a_tmp = []
               a_tmp.push(prop.content)   
               link.each { |link| a_tmp.push(link['href']) }
               one_post_data.push(a_tmp)
            else
              one_post_data.push(prop.content)
            end            
          end
          @post_url_array.push(one_post_data)
        end
        #puts @post_url_array.inspect 
      end

      def fetche_post(url)
        response = Faraday.get(url)
        case response.status
        when 200
          @html = response.body
        when 301..302
          @html = Faraday.get(response[:Location])
        end
        page = Nokogiri::HTML(@html)
        post = page.css("#js_content").inner_html
        return post
      end

      def convert_to_markdown(html, first_line="\n")
        ReverseMarkdown.config do |config|
          config.unknown_tags     = :bypass
          config.github_flavored  = true
          config.tag_border  = ' '
        end
        result = ReverseMarkdown.convert(html)
        string_io = StringIO.new(result)
        string_array = string_io.readlines
        
        string_array.reverse_each do |line|
          if line.include?("![]")
            string_array.pop
          else
            break
          end
        end
        
        string_array.each do |line|
          line.gsub!(QQ_WEIXIN_PIC_PATH, WEICDN_PATH)
          line.gsub!(/\*\*\s+/, '**')
        end
        string_array.unshift(first_line)
        return string_array.join("\n") 
      end

      def insert_to_81kb(title, markdown_content)
        @api.post_to_81kb(WEIXIN_CATEGORY, title, markdown_content)
      end

      def post_all
        fetch_urls
        @post_url_array.first(3).each do |e|
          author = e[0][0]
          title  = e[1][0]
          post_url = e[1][1]
          visit_count = e[3]
          like_count = e[4]
          
          first_line = POST_HEADER % [visit_count, like_count, author]
          html = fetche_post(post_url)
          markdown_content = convert_to_markdown(html, first_line)
          insert_to_81kb(title, markdown_content)
        end
      end

    end

  end
end


