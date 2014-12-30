Dir[Rails.root.join("spec/support/features/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Features::BootstrapHelpers, type: :feature
  config.include Features::DataHelpers, type: :feature
end