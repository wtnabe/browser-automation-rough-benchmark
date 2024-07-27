require "selenium-webdriver"
require "capybara/dsl"
require "benchmark"

class CapybaraRunner
  include Capybara::DSL

  def call(times = 10)
    times.times do
      Capybara.default_driver = :selenium_chrome_headless

      visit "https://github.com/wtnabe"
      
      click_link("Repositories")
      find("#your-repos-filter").set("example")
      first(:xpath, "//h3/a[contains(text(), 'example')]").click
      page.driver.reset!
    end
  end
end

def capybara(times = 10)
  CapybaraRunner.new.call(times)
end

def vanilla(times = 10)
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")

  times.times do
    driver = Selenium::WebDriver.for :chrome, options: options

    ele = nil
    wait = Selenium::WebDriver::Wait.new(timeout: 3)

    driver.navigate.to "https://github.com/wtnabe"
    
    wait.until {
      ele = driver.find_element(css: 'a[data-tab-item="repositories"]')
    }
    ele.click
    wait.until {
      ele = driver.find_element(id: 'your-repos-filter')
    }
    ele.send_keys("example")
    wait.until {
      ele = driver.find_element(xpath: "//h3/a[contains(text(), 'example')]")
    }
    ele.click
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
