#!/usr/bin/ruby
# @Author: xhb
# @Date:   2016-07-14 23:56:41
# @Last Modified by:   xhb
# @Last Modified time: 2016-07-31 15:13:22

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require "dis_fetcher"
weixin = DisFetcher::Post::Weixin.new
#weixin.post_all
html = weixin.fetche_post("http://chuansong.me/n/466387551142")
md = weixin.convert_to_markdown(html)
weixin.insert_to_81kb("测试卡哇微卡", md)

