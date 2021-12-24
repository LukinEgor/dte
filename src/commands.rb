require 'faraday'
require 'nokogiri'
require 'byebug'

module Commands
  class DownloadRequirements
    HEADERS = ['Что нужно будет делать:', 'Основные задачи:', 'Задачи:', 'МЫ ДОВЕРИМ ВАМ ЗАДАЧИ:']

    def self.run(url)
      response = Faraday.get(url)
      response.body

      doc = Nokogiri::HTML(response.body)

      header_item = doc.xpath("//p").find { |p| HEADERS.include? p.text.strip }
      content_item = header_item.next_element
      raw_requirements_items = content_item.children.map(&:text)
      requirements = raw_requirements_items.select { |item| item.match(/\p{L}/) }

      requirements
    end
  end

  class Executor
    COMMANDS = [
      '@job_req': Commands::DownloadRequirements
    ]

    def self.run(config)
      config.map do |k, v|
        tokens = v.split(' ')
        next [k, v] unless tokens.first == '@job_req'

        params = tokens.slice(1..-1)
        prepared_value = Commands::DownloadRequirements.run(params[0])
        [k, prepared_value]
      end.to_h
    end
  end
end
