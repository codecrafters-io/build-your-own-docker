require "open3"

command = ARGV[2]
args = ARGV[3..ARGV.length]

stdout, stderr, status = Open3.capture3(command, *args)

if stderr != ''
  puts "Error: ", stderr
end

puts stdout
