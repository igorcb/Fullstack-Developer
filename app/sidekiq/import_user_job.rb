class ImportUserJob
  include Sidekiq::Job

  def perform(*args)
    puts "Import Job User"
  end
end
