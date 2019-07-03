# frozen_string_literal: true

require 'tempfile'

describe CiOverhead do
  EXAMPLE_SPEC_FILE = 'spec/spec_examples.rb'

  let(:iso_results) { run_rspec_with_formatter('IsoFormatter') }

  def with_tempfile
    t = Tempfile.new('cioverhead')
    yield t if block_given?
  end

  def run_rspec_with_formatter(formatter)
    with_tempfile do |output|
      cmd = ['bundle', 'exec', 'rspec', '--format', formatter, '--out', output.path, EXAMPLE_SPEC_FILE]
      system(*cmd)
      output.read
    end
  end

  it 'has a version number' do
    expect(CiOverhead::VERSION).not_to be nil
  end

  it 'produces iso documentation output' do
    expect(iso_results).to include("PASS-One      \tPASS   \tComponent is positive", 'PASS-Two')
  end

  it 'includes a summary line' do
    expect(iso_results).to include('TOTAL: 2 examples')
  end

end
