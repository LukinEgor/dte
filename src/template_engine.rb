require 'byebug'
require 'docx'

class TemplateEngine
  attr_reader :doc

  def initialize(template)
    @template = template
    @config = {}
    @doc = template.clone
  end

  def configure &block
    yield @config
  end

  def render
    @doc.paragraphs.each do |p|
      @config.each do |key, value|
        next unless p.text.include? key

        if value.class == String
          p.text = p.text.gsub!(key, value)
        end

        if value.class == Array
          value.reverse.each do |value_item|
            copied_p = p.copy
            copied_p.text = copied_p.text.gsub!(key, value_item)
            p.node.add_next_sibling(copied_p.node)
          end
          p.remove!
        end
      end
    end
  end

  def save(path)
    @doc.save(path)
  end
end
