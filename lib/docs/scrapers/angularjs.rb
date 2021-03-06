module Docs
  class Angularjs < UrlScraper
    self.name = 'Angular.js'
    self.slug = 'angularjs'
    self.type = 'angularjs'
    self.root_path = 'api.html'
    self.initial_paths = %w(guide.html)

    html_filters.push 'angularjs/clean_html', 'angularjs/entries', 'title'
    text_filters.push 'angularjs/clean_urls'

    options[:title] = false
    options[:root_title] = 'Angular.js'

    options[:decode_and_clean_paths] = true
    options[:fix_urls_before_parse] = ->(str) do
      str.gsub!('[', '%5B')
      str.gsub!(']', '%5D')
      str
    end

    options[:fix_urls] = ->(url) do
      %w(api guide).each do |str|
        url.sub! "/partials/#{str}/#{str}/", "/partials/#{str}/"
        url.sub! %r{/#{str}/img/}, '/img/'
        url.sub! %r{/#{str}/(.+?)/#{str}/}, "/#{str}/"
        url.sub! %r{/partials/#{str}/(.+?)(?<!\.html)(?:\z|(#.*))}, "/partials/#{str}/\\1.html\\2"
        url.sub! %r{/partials/(?!img).+/#{str}/}, "/partials/#{str}/"
      end
      url
    end

    options[:only_patterns] = [%r{\Aapi}, %r{\Aguide}]
    options[:skip] = %w(api/ng.html)

    options[:attribution] = <<-HTML
      &copy; 2010&ndash;2016 Google, Inc.<br>
      Licensed under the Creative Commons Attribution License 4.0.
    HTML

    stub '' do
      capybara = load_capybara_selenium
      capybara.app_host = 'https://code.angularjs.org'
      capybara.visit("/#{self.class.release}/docs/api")
      capybara.execute_script("return document.querySelector('.side-navigation').innerHTML")
    end

    version '1.5' do
      self.release = '1.5.9'
      self.base_url = "https://code.angularjs.org/#{release}/docs/partials/"
    end

    version '1.4' do
      self.release = '1.4.14'
      self.base_url = "https://code.angularjs.org/#{release}/docs/partials/"
    end

    version '1.3' do
      self.release = '1.3.20'
      self.base_url = "https://code.angularjs.org/#{release}/docs/partials/"
    end

    version '1.2' do
      self.release = '1.2.32'
      self.base_url = "https://code.angularjs.org/#{release}/docs/partials/"
    end
  end
end
