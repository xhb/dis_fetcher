#!/usr/bin/ruby
# @Author: xhb
# @Date:   2016-07-14 23:56:41
# @Last Modified by:   xhb
# @Last Modified time: 2016-07-17 12:59:03

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require "dis_fetcher"
weixin = DisFetcher::Post::Weixin.new
weixin.post_all
