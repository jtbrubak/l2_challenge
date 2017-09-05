require 'nokogiri'
require 'mechanize'
require 'csv'
require 'byebug'

agent = Mechanize.new
page = agent.get('https://www.bestbuy.com/site/searchpage.jsp?cp=1&searchType=search&st=smart%20tv&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&nrp=&sp=&qp=&list=n&af=true&iht=y&usc=All%20Categories&ks=960&keys=keys')
# search_form = page.form(name: 'frmSearch')
# search_form.st = "smart tv"
# page = agent.submit(search_form)
File.open('links.txt', 'w') { |file| file << page.links }
all_results = []
num_results = page.search(".list-page").attribute('data-num-found').value.to_i
search_rank = 0
while all_results.length < num_results
  search_results = page.search(".list-item")
  File.open("file.txt", "w") { |file| file << search_results }
  search_results = search_results.map do |result|
    brand = result.get_attribute('data-name').split(" - ")[0]
    model_num = result.search('.model-number .sku-value').text
    rating = result.search('.star-rating-value').text
    num_ratings = result.search('.number-of-reviews').text
    search_rank += 1
    all_results.push({
        search_rank: search_rank,
        brand: brand,
        model_num: model_num,
        rating: rating,
        num_ratings: num_ratings
    })
  end
  next_link = page.link_with(search: '.pager-next a')
  page = next_link.click
end
CSV.open("file.csv", "w") do |csv|
  all_results.each do |result|
    csv << [result[:search_rank], result[:brand], result[:model_num], result[:rating], result[:num_ratings]]
  end
end
