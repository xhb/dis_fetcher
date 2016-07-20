# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dis_fetcher/version'

Gem::Specification.new do |spec|
  spec.name          = "dis_fetcher"
  spec.version       = DisFetcher::VERSION
  spec.authors       = ["xhb"]
  spec.email         = ["programstart@163.com"]

  spec.summary       = "下载最新的微信文章和最新的优酷视频到我的 81kb.com "
  spec.description   = "下载最新的微信文章和最新的优酷视频到我的 81kb.com "
  spec.homepage      = "http://81kb.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
