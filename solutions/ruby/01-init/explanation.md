The entry point for your Docker implementation is in `app/main.rb`.

Study and uncomment the relevant code: 

```ruby
# Uncomment this block to pass the first stage

command = ARGV[2]
args = ARGV[3..]

stdout, stderr, status = Open3.capture3(command, *args)

puts stdout
```

Push your changes to pass the first stage:

```
git add .
git commit -m "pass 1st stage" # any msg
git push origin master
```
