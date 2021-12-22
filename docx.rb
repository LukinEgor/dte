require 'docx'
require 'byebug'
require 'rubyXL'

template_path = './template_origin.docx'
dest_path = './template_copied.docx'
table_path = 'table.xlsx'

workbook = RubyXL::Parser.parse(table_path)

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


configs.map do |config|
  doc = Docx::Document.open(template_path)
  file_name = "#{config['file_name']}.docx"

  doc.paragraphs.each do |p|
    p.each_text_run do |tr|
      config.each do |k, v|
        tr.substitute("@#{k}", v)
        tr.substitute("@tasks", '- aaa<w:br/>- bbb')
      end
    end
  end

  doc.save(file_name)

  doc.paragraphs.each_with_index { |p| puts p }
end
