require 'csv'

class CsvCreatorWorker
  include Sidekiq::Worker

  CSV_PATH = Rails.root.join('tmp', 'csv')
  TYPES = %w(people products orders orders_products)
  TASK_SIZE = 1_000
  PRODUCTS_SIZE = 10_000
  PEOPLE_SIZE = 1_000_000
  ORDERS_SIZE = PEOPLE_SIZE * 3
  ORDERS_PRODUCTS_SIZE = ORDERS_SIZE * 3

  def people(id)
    [
      id,
      Faker::Internet.email,
      Faker::Name.first_name,
      Faker::Name.last_name
    ]
  end

  def people_header_row
    Person.columns.map { |column| column.name == 'id' ? 'person_id' : column.name }
  end

  def products(id)
    [
      id,
      Faker::Commerce.product_name,
      Faker::Commerce.price,
      Faker::Code.asin,
      Faker::Commerce.color,
      Faker::Commerce.department,
      Faker::Hipster.sentences.join(' ')
    ]
  end

  def products_header_row
    Product.columns.map { |column| column.name == 'id' ? 'product_id' : column.name }
  end

  def orders(id)
    [id, (id/3.to_f).ceil]
  end

  def orders_header_row
    %w(order_id person_id)
  end

  def orders_products(id)
    [id, (id/3.to_f).ceil, Random.rand(1..10_000)]
  end

  def orders_products_header_row
    %w(order_product_id order_id product_id)
  end

  def perform(type, ids, padding)
    file_name = "#{type}__#{ids.first.to_s.rjust(padding, '0')}_#{ids.last.to_s.rjust(padding, '0')}.csv"
    file_path = Rails.root.join('tmp', 'csv', file_name)
    CSV.open(file_path, 'wb') do |csv|
      ids.each do |id|
        if id == 1
          csv << send("#{type}_header_row")
        end
        csv << send(type, id)
      end
    end
  end

  def self.export_csv_files
    export_path = CSV_PATH.join('export')
    FileUtils.mkdir_p export_path

    TYPES.each do |type|
      csv_path = "#{export_path}/#{type}.csv"
      sql = "COPY #{type} TO ? DELIMITER ',' CSV;"
      query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, csv_path])
      ActiveRecord::Base.connection.execute(query)
    end
  end

  def self.import_csv_files
    TYPES.each do |type|
      csv_path = "#{CSV_PATH}/#{type}.csv"
      sql = "COPY #{type} FROM ? DELIMITER ',' CSV;"
      query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, csv_path])
      ActiveRecord::Base.connection.execute(query)
    end
  end

  def self.join_all_csv_files
    TYPES.each do |type|
      `find #{CSV_PATH} -name "#{type}__*.csv" -exec cat {} + > #{CSV_PATH}/#{type}.csv`
    end
  end

  def self.queue_all_jobs
    Dir.mkdir(CSV_PATH) unless Dir.exist?(CSV_PATH)

    TYPES.each do |type|
      job_size = const_get("#{type}_size".upcase)
      padding = job_size.to_s.length

      (1..job_size).each_slice(TASK_SIZE) do |i|
        CsvCreatorWorker.perform_async(type, i, padding)
      end
    end
  end
end
