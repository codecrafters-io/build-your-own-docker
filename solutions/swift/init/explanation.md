The entry point for your Docker implementation is in `Sources/swift-docker-challenge/Main.swift`.

Study and uncomment the relevant code: 

```swift
// Uncomment this block to pass the first stage!
let command = CommandLine.arguments[3]
let arguments = CommandLine.arguments.dropFirst(4).map { String($0) }
let process = Process()
process.executableURL = URL(fileURLWithPath: command)
process.arguments = arguments
try process.run()
process.waitUntilExit()
guard process.terminationStatus == .zero, let output = process.standardOutput as? String else {
    exit(1)
}
print(output)
```

Push your changes to pass the first stage:

```
git add .
git commit -m "pass 1st stage" # any msg
git push origin master
```
