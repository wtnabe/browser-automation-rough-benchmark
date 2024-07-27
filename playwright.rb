require "playwright"
require "capybara-playwright-driver"
require "capybara/dsl"
require "benchmark"

class CapybaraRunner
  include Capybara::DSL

  def call(times = 10)
    Capybara.register_driver(:playwright) do |app|
      Capybara::Playwright::Driver.new(
        app,
        browser_type: :chromium
      )
    end
    Capybara.default_driver = :playwright

    times.times do
      visit "https://github.com/wtnabe"

      click_link("Repositories")
      find("#your-repos-filter").set("example")
      first(:xpath, "//h3/a[contains(text(), 'example')]").click
    end
  end
end

def capybara(times = 10)
  CapybaraRunner.new.call(times)
end

def vanilla(times = 10)
  Playwright.create(playwright_cli_executable_path: "./node_modules/.bin/playwright") do |playwright|
    playwright.chromium.launch do |browser|

      times.times do
        page = browser.new_page
        page.goto "https://github.com/wtnabe"

        page.locator("css=a[data-tab-item='repositories']").nth(0).click
        page.locator("#your-repos-filter").fill("example")
        page.locator("xpath=//h3/a[contains(text(), 'example')]").nth(0).click
      end
    end
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
