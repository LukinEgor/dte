require 'docx'
require 'byebug'
require 'rubyXL'

require_relative 'src/template_engine.rb'
require_relative 'src/commands.rb'

template_path = './template_origin.docx'
dest_path = './template_copied.docx'
table_path = 'table.xlsx'

template = Docx::Document.open(template_path)
@template_engine = TemplateEngine.new(template)

workbook = RubyXL::Parser.parse(table_path)

# Setup config
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

# Exec commands

updated_configs = configs.map { |config| Commands::Executor.run(config) }

# Create to docs
updated_configs.map do |config|
  file_name = "#{config['file_name']}.docx"

  @template_engine.config = config

  @template_engine.render

  p @template_engine.doc.text


  @template_engine.save(file_name)
end
