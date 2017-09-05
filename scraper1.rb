require 'oga'
require 'open-uri'
require 'csv'
require 'date'

def run(search_term)
  all_results = []
  page_num = 1
  page = open(get_url(page_num, search_term))
  oga_page = Oga.parse_html(page)
  num_results = oga_page.css(".results-tabs a")[0].attribute('data-count').value.to_i
  while all_results.length < num_results
    oga_page = Oga.parse_html(open(get_url(page_num, search_term))) unless all_results.empty?
    all_results.concat(scrape_page(oga_page, ((page_num - 1) * 24)))
    page_num += 1
  end
  write(all_results)
end

def get_url(page_num, search_term)
  "https://www.bestbuy.com/site/searchpage.jsp?cp=#{page_num}&searchType=search&st=#{search_term}&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&nrp=&sp=&qp=&list=n&af=true&iht=y&usc=All%20Categories&ks=960&keys=keys"
end

def scrape_page(oga_page, search_rank)
  rows = []
  search_results = oga_page.css(".list-item")
  search_results.map do |result|
    brand = result.attribute('data-name').value.split(" - ")[0]
    model_num = result.css('.model-number .sku-value').text
    rating = result.css('.star-rating-value').text
    num_ratings = result.css('.number-of-reviews').text
    search_rank += 1
    rows.push({
        search_rank: search_rank,
        brand: brand,
        model_num: model_num,
        rating: rating,
        num_ratings: num_ratings
    })
  end
  rows
end

def write(results)
  file = "#{ARGV.join(" ")} #{DateTime.now.strftime('%m-%d-%Y')}.csv"
  CSV.open(file, "w") do |csv|
    csv << ["Search Rank", "Brand", "Model", "Rating", "Number of Ratings"]
    results.each do |result|
      csv << [result[:search_rank], result[:brand], result[:model_num], result[:rating], result[:num_ratings]]
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  run(ARGV.join("%20"))
end
