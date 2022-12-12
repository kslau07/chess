desc "Run PCMag tests"
  RSpec::Core::RakeTask.new('test') do |t|
  t.rspec_opts = ["-Ilib","--format documentation","--color"]
  t.pattern = ['spec/test/*_spec.rb']
end
