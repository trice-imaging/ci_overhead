if defined?(Rake)
  fn = File.absolute_path('../tasks/ci.rake', File.dirname(__FILE__))
  Rake.application.add_import(fn)
end
