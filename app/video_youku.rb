#!/usr/bin/ruby
# @Author: xhb
# @Date:   2016-07-17 23:50:08
# @Last Modified by:   xhb
# @Last Modified time: 2016-07-18 23:55:03
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require "dis_fetcher"
youku = DisFetcher::Video::YouKu.new

youku.fetch_youku_first_video
youku.fetch_youku_first_page_self_make_video
youku.commite_all_video
