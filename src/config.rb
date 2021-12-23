require 'rubyXL'
class Config
  def self.parse_table(config_path)
    workbook = RubyXL::Parser.parse(config_path)

    configs = []
    keys = workbook.worksheets[0].sheet_data[0].cells.map(&:value)
    rows_with_data = workbook.worksheets[0].sheet_data.rows.slice(1..-1)

    rows_with_data.each do |row|
      config = {}
      keys.each_with_index do |key, index|
        value = row[index].value
        config[key] = value
      end

      configs << config
    end

    configs
  end
end
