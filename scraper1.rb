require 'oga'
require 'open-uri'
require 'csv'
require 'byebug'

all_results = []
page_num = 1
search_rank = 0
page = open("https://www.bestbuy.com/site/searchpage.jsp?cp=#{page_num}&searchType=search&st=curved%20smart%20tv&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&nrp=&sp=&qp=&list=n&af=true&iht=y&usc=All%20Categories&ks=960&keys=keys")
oga_page = Oga.parse_html(page)
num_results = oga_page.css(".results-tabs a")[0].attribute('data-count').value.to_i
while all_results.length < num_results
  p num_results
  search_results = oga_page.css(".list-item")
  search_results.each do |result|
    brand = result.attribute('data-name').value.split(" - ")[0]
    model_num = result.css('.model-number .sku-value').text
    rating = result.css('.star-rating-value').text
    num_ratings = result.css('.number-of-reviews').text
    search_rank += 1
    all_results.push({
        search_rank: search_rank,
        brand: brand,
        model_num: model_num,
        rating: rating,
        num_ratings: num_ratings
    })
  end
  page_num += 1
end
CSV.open("file1.csv", "w") do |csv|
  all_results.each do |result|
    csv << [result[:search_rank], result[:brand], result[:model_num], result[:rating], result[:num_ratings]]
  end
end
