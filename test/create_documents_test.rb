require 'minitest/autorun'
require "wrong"
require_relative '../src/create_documents.rb'

class CreateDocumenstTest < MiniTest::Unit::TestCase
  include Wrong

  def test_creating_documents
    template_path = '/app/test/fixtures/template.docx'
    config_path = '/app/test/fixtures/config.xlsx'

    timestamp = Time.now.to_i
    generated_files_path = "/tmp/#{timestamp}"

    documents_archive_path = CreateDocuments.call(template_path, config_path, generated_files_path)

    assert { documents_archive_path.present? }
  end
end
