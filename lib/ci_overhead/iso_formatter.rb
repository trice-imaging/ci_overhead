# frozen_string_literal: true

require 'rspec/core'
require 'rspec/core/formatters/base_formatter'
require 'time'

class IsoFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :start, :example_failed, :example_passed,
                                   :example_pending, :seed, :dump_summary

  RESULT_PASS = 'PASS'
  RESULT_FAIL = 'FAIL'
  RESULT_PENDING = 'PENDING'
  RESULT_SKIPPED = 'SKIPPED'

  def start(notification)
    super
    @examples = []
    output.puts "Executing tests at #{Time.now.iso8601}\n\n"
  end

  def example_passed(notification)
    format(notification, RESULT_PASS)
  end

  def example_failed(notification)
    format(notification, RESULT_FAIL)
  end

  def example_pending(notification)
    format(notification, RESULT_PENDING)
  end

  def example_skipped(notification)
    format(notification, RESULT_SKIPPED)
  end

  def dump_summary(_summary)
    @examples.sort!
    @examples.each { |e| @output.puts e }
    print_summary_totals
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

  def print_summary_totals
    totals = String.new(
      "\n\nTOTAL: #{example_count} example#{'s' unless example_count == 1}, "
    )
    totals << "#{failure_count} failure#{'s' unless failure_count == 1}"
    totals << ", #{pending_count} pending" if pending_count.positive?

    @output.puts totals
  end

  def example_count
    @examples.count
  end

  def pending_count
    @examples.count { |x| x[1] == RESULT_PENDING }
  end

  def failure_count
    @examples.count { |x| x[1] == RESULT_FAIL }
  end
end
