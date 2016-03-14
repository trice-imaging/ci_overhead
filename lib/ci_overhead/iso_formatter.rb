require 'rspec/core'
require 'rspec/core/formatters/base_formatter'

class IsoFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :start, :example_failed, :example_passed, :example_pending, :seed, :dump_summary

  def start(notification)
    super
    @examples = []
    output.puts "Executing tests at #{Time.now.iso8601}\n\n"
  end

  def example_passed(notification)
    format(notification, 'PASS')
  end

  def example_failed(notification)
    format(notification, 'FAIL')
  end

  def example_pending(notification)
    format(notification, 'PENDING')
  end

  def example_skipped(notification)
    format(notification, 'SKIPPED')
  end

  def dump_summary(notification)
    @examples.sort!
    @examples.each { |e| @output.puts e }
  end

  def seed(notification)
    return unless notification.seed_used?
    output.puts notification.fully_formatted
  end

  private

  def iso_ids(notification)
    # May later group together example + group ids, if necessary
    notification.example.metadata.fetch(:iso_id, '')
  end

  def format(notification, result)
    # Only print out tests with ISO ids
    return if iso_ids(notification).empty?
    @examples << [iso_string(notification), result.ljust(7), description(notification)].join("\t")
  end

  def iso_string(notification)
    ids = iso_ids(notification)
    return '' if ids.empty?
    ids.to_s.ljust(14)
  end

  def description(notification)
    # Need group description, if exists?
    notification.example.full_description.strip
  end
end
