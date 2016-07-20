require "bundler/gem_tasks"
require "rspec/core/rake_task"
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require "dis_fetcher"

desc "Auto fetch weixin post to 81kb.com"
task :insert_weixin do
  weixin = DisFetcher::Post::Weixin.new
  weixin.post_all
end

desc "Auto fetch youku video to 81kb.com"
task :insert_youku do
  youku = DisFetcher::Video::YouKu.new
  youku.fetch_youku_first_video
  youku.fetch_youku_first_page_self_make_video
  youku.commite_all_video
end


RSpec::Core::RakeTask.new(:spec)
task :default => :spec
