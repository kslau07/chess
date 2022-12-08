RSpec.configure do |config|
  config.before(:all) { puts 'Before :all' }
  config.after(:all) { puts 'After :all' }
  config.before(:suite) { puts 'Before :suite' } # runs once before all examples
  config.after(:suite) { puts 'After :suite' } # runs once after all examples
end

describe 'spec1' do
  example 'spec1' do
    puts 'spec1'
  end
end

describe 'spec2' do
  example 'spec2' do
    puts 'spec2'
  end
end
