include ActiveJob::TestHelper

RSpec.configure do |config|
  config.after(:each) do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
