require 'open-uri'
require 'nokogiri'

namespace :scraping do
  desc "ヤフートップページのtitleタグの中身を取得する"
  task :get_yahoo_title => :environment do
    target_url = 'http://www.yahoo.co.jp/'
    charset = nil
    html = open(target_url) do |f|
      charset = f.charset
      f.read
    end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)
    @article = Article.new(:title => doc.title)
    @article.save
    puts doc.title
  end

  desc "NaverまとめのTechページの注目一覧のタイトル・画像を取得"
  task :get_naver_popular_titles => :environment do
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

      p link
      p image_path
      p title

      @article = Article.new(:title => title, :image_path => image_path, :link => link)
      @article.save
    end
  end

  desc "ハウコレの恋愛カテゴリを取得"
  task :get_howcollect_love_articles => :environment do 
    target_url = "http://howcollect.jp/list/index/category/1"
    charset = nil
    html = open(target_url) do |f|
      charset = f.charset
      f.read
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)

    doc.xpath('//li[@class="line-article"]').each do |node|
      link = node.css("a").attribute("href").value
      image_path = node.css('img').attribute('src').value
      title = node.css('h3').inner_text
      summary = node.css('.introduction').inner_text
      published_date = node.css('.font-styled-date').inner_text

      p link
      p image_path
      p title
      p summary
      p published_date

      @article = Article.new(:title => title, :image_path => image_path, :link => link, :summary => summary, :published_date => published_date)
      @article.save
    end
  end
end