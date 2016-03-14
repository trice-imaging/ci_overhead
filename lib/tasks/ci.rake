namespace :ci do
  # multitask seems to have some issue when one of the processes has a failure. Seeing orphaned processes after exit.
  # desc 'Run standard ci tasks (w/o reporting)'
  # multitask all: %w(ci:tests ci:rubocop ci:brakeman)

  desc 'Run tests'
  task tests: :environment do
    # Keeping around html output for Jenkins showing overall results
    # Outputting iso_tests.txt for ISO documentation
    ENV['SPEC_OPTS'] = ' --format html --out spec/reports/results.html'\
      ' --require=ci_overhead --format IsoFormatter --out spec/reports/iso_tests.txt'\
      ' --require=rspec_junit_formatter --format RspecJunitFormatter --out spec/reports/rspec.xml'\
      ' --format d'

    Rake::Task['spec'].invoke
  end

  desc 'Run RuboCop with CI arguments'
  task :rubocop do
    require 'rubocop'
    cli = RuboCop::CLI.new
    cli.run(%w(--display-style-guide
               --rails
               --no-color
               --require rubocop/formatter/checkstyle_formatter
               --format RuboCop::Formatter::CheckstyleFormatter
               --out tmp/checkstyle.xml
               --format d))
  end

  desc 'Run Brakeman scanner'
  task :brakeman, :output_files do |_t, args|
    require 'brakeman'

    files = args[:output_files].split(' ') if args[:output_files]
    files ||= ['brakeman-output.tabs']
    run = Brakeman.run(app_path: '.', output_files: files, print_report: true, min_confidence: 1)
    puts "Brakeman finished (#{run})"
  end

  desc 'Update the ruby advisory database and audit'
  task :audit do
    require 'bundler/audit/cli'
    # They don't make it easy to capture and redirect output.
    # Run separately, or if wanted in ci:all, run commands in a shell
    %w(update check).each do |command|
      Bundler::Audit::CLI.start [command]
    end
  end
end
