require 'open-uri'
require 'nokogiri'

namespace :get_naver_popular_titles do
  desc "NaverまとめのTechページの注目一覧のタイトル・画像を取得"
  task :exec_nokogiri => :environment do
    target_url = "http://matome.naver.jp/tech"
    charset = nil

    html = open(target_url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)

    doc.xpath('//li[@class="mdTopMTMList01Item"]').each do |node|
      # tilte
      title = node.css('h3').inner_text

      # 記事のサムネイル画像
      image_path = node.css('img').attribute('src').value

      # 記事のリンク
      link = node.css('a').attribute('href').value

      @article = Article.new(:title => title, :image_path => image_path, :link => link)
      @article.save
    end
  end

end
