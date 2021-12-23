require 'sinatra'
require 'byebug'
require 'docx'
require 'rubyXL'
require 'zip'

require_relative 'template_engine.rb'
require_relative 'commands.rb'

include FileUtils::Verbose

set :bind, '0.0.0.0'
set :port, ENV['PORT']

get '/' do
  send_file 'src/view.html'
end

def upload_file(params, name)
  tempfile = params[name][:tempfile]
  filename = params[name][:filename]
  path = "uploads/#{filename}"
  cp(tempfile.path, path)
  path
end

def parse_config(config_path)
  workbook = RubyXL::Parser.parse(config_path)

  configs = []
  keys = workbook.worksheets[0].sheet_data[0].cells.map(&:value)
  rows_with_data = workbook.worksheets[0].sheet_data.rows.slice(1..-1)

  rows_with_data.each do |row|
    config = {}
    keys.each_with_index do |key, index|
      value = row[index].value.to_s
      config[key] = value
    end

    configs << config
  end

  configs
end

def create_files_from_template(configs, template_path, dir_path)
  template = Docx::Document.open(template_path)
  template_engine = TemplateEngine.new(template)

  configs.map do |config|
    file_name = "#{dir_path}/#{config['file_name']}.docx"

    template_engine.config = config

    template_engine.render

    p template_engine.doc.text

    template_engine.save(file_name)
  end
end

def create_zip_archive(dir_path)
  filenames = Dir.entries(dir_path).reject { |e| ['..', '.'].include? e }
  zipfile_name = "#{dir_path}/archive.zip"

  Zip::File.open(zipfile_name, create: true) do |zipfile|
    filenames.each do |filename|
      zipfile.add(filename, File.join(dir_path, filename))
    end
    zipfile.get_output_stream("myFile") { |f| f.write "myFile contains just this" }
  end

  zipfile_name
end

post '/upload' do
  template_path = upload_file(params, 'template')
  config_path = upload_file(params, 'config')

  configs = parse_config(config_path)
  updated_configs = configs.map { |config| Commands::Executor.run(config) }
  p updated_configs

  timestamp = Time.now.to_i
  files_path = "uploads/#{timestamp}"
  Dir.mkdir files_path
  create_files_from_template(updated_configs, template_path, files_path)

  archive_path = create_zip_archive(files_path)
  send_file archive_path
end
