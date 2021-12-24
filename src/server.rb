require 'sinatra'
require_relative 'create_documents.rb'
require_relative 'upload_file_helper.rb'

include UploadFileHelper
extend UploadFileHelper

set :bind, '0.0.0.0'
set :port, ENV['PORT']

get '/' do
  send_file 'src/view.html'
end

post '/upload' do
  template_path = upload_file(params, 'template')
  config_path = upload_file(params, 'config')

  timestamp = Time.now.to_i
  generated_files_path = "uploads/#{timestamp}"

  documents_archive_path = CreateDocuments.call(template_path, config_path, generated_files_path)

  send_file documents_archive_path
end
