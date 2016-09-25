require 'open-uri'
require 'nokogiri'

namespace :get_yahoo_title do
  desc "ヤフートップページのtitleタグの中身を取得する"
    task :exec_nokogiri => :environment do
      target_url = 'http://www.yahoo.co.jp/'
      charset = nil
      html = open(target_url) do |f|
        charset = f.charset
        f.read
      end

      # htmlをパース(解析)してオブジェクトを生成
      doc = Nokogiri::HTML.parse(html, nil, charset)
      puts doc.title
      @article = Article.new(:title => doc.title)
      @article.save
    end
end
