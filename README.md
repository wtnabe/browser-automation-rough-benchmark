## Browser Automation API Benchmark

### Environment

 * MacBook Air 2020
 * Apple M1
 * 16GB
 * macOS 13.6.7
 * USB-C Ether 1Gbps ( 回線も 1Gbps )
 * Ruby 3.2.2

### Frameworks

 * Selenium::WebDriver
 * Playwright
 * Ferrum ( Chrome DevTools Protocol wrapper )

### Tests

10 times

 * goto github.com
 * open repositories tab
 * search "example"
 * navigate first result repo

### Results

Framework         | user      | system   |   total (real)
-------------------|----------|----------|---------------------
ferrum x vanilla   | 0.848528 | 0.440863 | 1.289391 ( 15.908533)
&nbsp;             | 2.04     | 1.17     | 16.30
ferrum x capybara  | 0.730165 | 0.416640 | 1.146805 ( 11.993278)
&nbsp;             | 8.23     | 1.92     | 13.65
selenium x vanilla |  0.048818 | 0.064239 | 0.542292 ( 16.440320)
&nbsp;             | 2.65     | 2.42      | 18.91
selenium x capybara | 0.087117 | 0.024265 | 0.152338 (  5.799557)
&nbsp;              | 1.76     | 0.94     | 7.09
playwright x vanilla | 0.604772 | 0.132642 | 0.737414 ( 10.869758)
&nbsp;               | 1.02     | 0.33     | 12.32
playwright x capybara |  0.337795 | 0.067931 | 0.405726 (  5.903433)
&nbsp;                | 0.69      | 0.24     | 7.08

### 感想

 * 全体に Vanilla より Capybara を使う方が速いのはブラウザを効率的にリセットする方法が分かっていないからかも
    * Slenium の driver インスタンスの生成、Ferrum の create_page, Playwright の new_page
 * Ferrum x Vanilla は sleep が必要で安定しないし適当な sleep を入れることで如実に遅くなる
 * Selenium を Capybara 経由で使う場合、意外に遅くないが、テストケースが少なすぎるのかもしれない
 * Playwright の Locator にクセあり
     * Locator 以外は auto-wait がいい具合に効いて書きやすそう


CDP を直接扱う Ferrum が思ったより全然速くならず、Flaky 要素も排除できていないのは課題に感じた。

メモリ消費は計測していないが、実行時間が遅くなるデメリットがなく、wait を自分で書く必要がない Playwright は Selenium に比べて明確にメリットがある。これでメモリ消費が軽ければ Locator のクセ以外は言うことない。

