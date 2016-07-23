require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "date"
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require "dis_fetcher"

desc "Auto fetch weixin post to 81kb.com"
task :insert_weixin do
  weixin = DisFetcher::Post::Weixin.new
  weixin.post_with_interval(80, 15.minutes)
end

desc "Auto fetch youku video to 81kb.com"
task :insert_youku do
  youku = DisFetcher::Video::YouKu.new
  youku.fetch_youku_first_video
  youku.fetch_youku_first_page_self_make_video
  youku.post_video_with_interval(80, 15.minutes)
end

desc "delete topics by date"
task :delete_topics do
  api = DisFetcher::DisApi.new()
  delete_day = Time.now - 7.days
  delete_day_str = delete_day.strftime("%Y%m%d")
  delete_day_str
  api.delete_topics_by_date(delete_day_str)
end

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
