# run-time arguments: test.rb "suite" "settings" "bs mode" "bs number(s)"

task :default => [:test]


# used for single runs
task :test do
  ruby 'test.rb "default" "default"'
end


# used for multiple test runs (stability testing)
task :soak do
  run_time = Time.now
  i = 0
  10.times {
    i += 1
    puts "Run " + i.to_s
    puts "Timepoint: " + ((Time.now - run_time)/60).round(2).to_s + "m"
    ruby 'test.rb "default" "default"'
  }
  puts "Runs executed: " + i.to_s
  puts "Run time: " + ((Time.now - run_time)/60).round(2).to_s + "m"
end
