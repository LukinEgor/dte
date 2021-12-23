require 'minitest/autorun'
require_relative '../src/template_engine.rb'

class TemplateEngineTest < MiniTest::Unit::TestCase
  def setup
    template_path = '/app/test/fixtures/template.docx'
    template = Docx::Document.open(template_path)
    @template_engine = TemplateEngine.new(template)
  end

  def test_insert_string
    value_for_replacement = 'test'
    @template_engine.configure do |config|
      config['@key'] = value_for_replacement
    end

    @template_engine.render

    assert_equal @template_engine.doc.text, value_for_replacement
  end

  def test_insert_multiple_strings
    value_for_replacement = ['first_line', 'second_line']

    @template_engine.configure do |config|
      config['@key'] = value_for_replacement
    end

    @template_engine.render

    assert_equal @template_engine.doc.text, value_for_replacement.join("\n")
    assert_equal @template_engine.doc.paragraphs.count, value_for_replacement.count
  end
end
