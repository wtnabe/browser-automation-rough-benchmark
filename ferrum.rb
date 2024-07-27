require "capybara/cuprite"
require "capybara/dsl"
require "ferrum"
require "benchmark"

class CapybaraRunner
  include Capybara::DSL

  def call(times = 10)
    times.times do
      Capybara.register_driver(:chrome) do |app|
        Capybara::Cuprite::Driver.new(app)
      end
      Capybara.default_driver = :chrome

      visit "https://github.com/wtnabe"
      
      click_link("Repositories")
      find("#your-repos-filter").set("example")
      sleep 0.1 # <- flaky
      first(:xpath, "//h3/a[contains(text(), 'example')]").click
      page.driver.reset!
    end
  end
end

def capybara(times = 10)
  CapybaraRunner.new.call(times)
end

def vanilla(times = 10)
  browser = Ferrum::Browser.new

  times.times do
    page = browser.create_page
    page.go_to "https://github.com/wtnabe"
    
    page.css("a[data-tab-item='repositories']").first.click
    sleep 0.8 # <- flaky
    page.at_css('#your-repos-filter').focus.type("example")
    ele = page.xpath("//h3/a[contains(text(), 'example')]").first
    ele.click
    browser
  end
end

if __FILE__ == $0
  framework = ARGV.shift || "vanilla"

  puts File.basename(__FILE__, ".rb") + " x " + framework
  puts Benchmark::CAPTION
  puts Benchmark.measure {
    send(framework)
  }
end
