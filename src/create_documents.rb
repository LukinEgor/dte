require 'docx'
require 'zip'
require_relative 'template_engine.rb'
require_relative 'commands.rb'
require_relative 'config.rb'

class CreateDocuments
  def self.call(template_path, config_path, generated_files_path)
    configs = Config.parse_table(config_path)
    updated_configs = configs.map { |config| Commands::Executor.run(config) }

    timestamp = Time.now.to_i
    files_path = "uploads/#{timestamp}"
    Dir.mkdir generated_files_path
    create_files_from_template(updated_configs, template_path, generated_files_path)

    archive_path = create_zip_archive(generated_files_path)
    archive_path
  end

  def self.create_files_from_template(configs, template_path, dir_path)
    template = Docx::Document.open(template_path)
    template_engine = TemplateEngine.new(template)

    configs.map do |config|
      file_name = "#{dir_path}/#{config['file_name']}.docx"

      template_engine.config = config

      template_engine.render
      template_engine.save(file_name)
    end
  end

  def self.create_zip_archive(dir_path)
    filenames = Dir.entries(dir_path).reject { |e| ['..', '.'].include? e }
    zipfile_name = "#{dir_path}/archive.zip"

    Zip::File.open(zipfile_name, create: true) do |zipfile|
      filenames.each do |filename|
        zipfile.add(filename, File.join(dir_path, filename))
      end
    end

    zipfile_name
  end
end
