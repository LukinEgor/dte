require 'minitest/autorun'
require_relative '../src/commands.rb'

class DownloadRequirementsTest < MiniTest::Unit::TestCase
  def test_extract_requirements_2
    config = {
      '@name': 'test',
      '@job_req': '@job_req https://ulyanovsk.hh.ru/vacancy/46131128?from=employer'
    }

    updated_config = Commands::Executor.run(config)

    assert_equal updated_config, {}
  end

  def test_extract_requirements
    # url = 'https://ulyanovsk.hh.ru/vacancy/46131128?from=employer'
    url = 'https://ulyanovsk.hh.ru/vacancy/46131128?from=employer'
    # url = 'https://ulyanovsk.hh.ru/vacancy/48983723?from=employer'
    # url = 'https://ulyanovsk.hh.ru/vacancy/44051201?from=employer'
    requirements = Commands::DownloadRequirements.run(url)

    assert_equal requirements, 1
  end
end
