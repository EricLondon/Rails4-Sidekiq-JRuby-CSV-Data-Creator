# Rails4 Sidekiq JRuby CSV Data Creator

This repo contains some code to generate CSV data using JRuby/Rails/Sidekiq and import the CSVs into Postgresql.

people -> orders -> orders_products <- products

Usage:
```
# rails setup
git clone <this repo>
bundle install
rake db:create && rake db:migrate

# terminal 1, start sidekiq
sidekiq

# terminal 2
# - generate csv files
# - join csv files
# - import csv files
rails c
> CsvCreatorWorker.queue_all_jobs
> CsvCreatorWorker.join_all_csv_files
> CsvCreatorWorker.import_csv_files
```
