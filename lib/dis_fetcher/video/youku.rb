#!/usr/bin/ruby
# @Author: xhb
# @Date:   2016-07-08 22:24:57
# @Last Modified by:   xhb
# @Last Modified time: 2016-07-21 00:52:37

require 'nokogiri'
require 'open-uri'
require 'faraday'
require 'reverse_markdown'
require 'stringio'

module DisFetcher
  module Video
    class YouKu
      
      YOUKU_FIRST_PAGE_URL = "http://www.youku.com/"
      VIDEO_CATEGORY = "看视频"

      def initialize
        @api = DisFetcher::DisApi.new
        @youku_video_links = []    
        @page = nil
      end
      
      def get_youku_html_struct(url)
        response = Faraday.get(url)
        case response.status
        when 200
          @html = response.body
        when 301..302
          @html = Faraday.get(response[:Location])
        end
        @page = Nokogiri::HTML(@html)
      end

      def fetch_youku_first_video
        youku_first_video_selector = "#m_223465 > div > div > div > div:nth-child(1) > div.yk-pack.yk-packs.mb20.pack-large > div"
        youku_first_page_tv_selector = "#m_223473 > div > div.yk-col8 > div > div"
        youku_first_page_et_selector = "#m_223495 > div > div.yk-col8 > div > div"
        youku_first_page_star_selector = "#m_223522 > div > div.yk-col8 > div > div"
        
        youku_first_page_all_selectors = [
          youku_first_video_selector,
          youku_first_page_tv_selector,
          youku_first_page_et_selector,
          youku_first_page_star_selector            
        ]

        get_youku_html_struct(YOUKU_FIRST_PAGE_URL)
        return if @page.nil?
        youku_first_page_all_selectors.each do |selector|
          youku_first_video_thumb = @page.css(selector)
          extract_info_from_thumb(youku_first_video_thumb)
        end  
      end
  
      def fetch_youku_first_page_self_make_video
        url = YOUKU_FIRST_PAGE_URL
        self_make_video_c = "#m_223847 > div > div.c"
        one_thumb = "div.p-thumb"
        get_youku_html_struct(url)
        all_self_make_thumb = @page.css(self_make_video_c).css(one_thumb)
        all_self_make_thumb.each do |thumb|
          extract_info_from_thumb(thumb)
        end
        @youku_video_links
      end

      def commite_all_video
        @youku_video_links.last(3).each do |link_info|
          markdown_content = convert_youku_info_to_markdown(link_info)
          insert_to_81kb(link_info[:title], markdown_content)
        end
      end

      def convert_youku_info_to_markdown(info)
        "####{info[:title]}\n---\n#{info[:href]}\n---\n![](#{info[:bg_pic]})\n"   
      end

      def insert_to_81kb(title, markdown_content)
        @api.post_to_81kb(VIDEO_CATEGORY, title, markdown_content)  
      end
      
      def extract_info_from_thumb(one_thumb)
        video_info = {}  
        one_thumb.css("a").each do |link|
          video_info[:href] = link["href"]
          video_info[:title] = link["title"]
        end
        one_thumb.css("img").each do |pic|
          video_info[:bg_pic] = pic["alt"]
        end  
        @youku_video_links.push(video_info)      
      end

    end
  end
end


