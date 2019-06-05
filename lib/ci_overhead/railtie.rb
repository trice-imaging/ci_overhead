class CiRailtie < ::Rails::Railtie
  rake_tasks do
    load 'tasks/ci.rake'
  end
end
