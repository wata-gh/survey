# overwrite db:migrate or db:dump
task 'db:migrate' => :environment do
  ENV['RAILS_ENV'] ||= "development"
  sh "bundle exec ridgepole -E#{ENV['RAILS_ENV']} -c config/database.yml --apply -f db/Schemafile"
  sh "bundle exec ridgepole -E#{ENV['RAILS_ENV']} -c config/database.yml --export -o db/Schemafile"
end

task 'db:dump' => :environment do
  ENV['RAILS_ENV'] ||= "development"
  sh "bundle exec ridgepole -E#{ENV['RAILS_ENV']} -c config/database.yml --export -o db/Schemafile"
end
