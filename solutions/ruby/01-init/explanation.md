The entry point for your Docker implementation is in `app/main.rb`.

Study and uncomment the relevant code: 

```ruby
# Uncomment this block to pass the first stage
require "open3"

command = ARGV[2]
args = ARGV[3..ARGV.length]

stdout, stderr, status = Open3.capture3(command, *args)

if stderr != ''
  puts "Error: ", stderr
end

puts stdout
```

Push your changes to pass the first stage:

```
git add .
git commit -m "pass 1st stage" # any msg
git push origin master
```
