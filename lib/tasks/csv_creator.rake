namespace :csv_creator do
  desc 'Creates all csv files'
  task people: :environment do
    CsvCreatorWorker.queue_all_jobs
  end
end
