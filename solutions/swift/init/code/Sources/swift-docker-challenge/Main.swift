import Foundation

@main
struct Main {

    // Usage: your_docker.sh run <image> <command> <arg1> <arg2> ...
    static func main() async throws {
        let process = Process()
        let command = CommandLine.arguments[3]
        let arguments = CommandLine.arguments.dropFirst(4).map { String($0) }
        #if canImport(Darwin)
            if #available(macOS 10.13, *) {
                process.executableURL = URL(fileURLWithPath: command)
                process.arguments = arguments
                try process.run()
            } else {
                process.launchPath = command
                process.arguments = arguments
                process.launch()
            }
        #else
            process.executableURL = URL(fileURLWithPath: command)
            process.arguments = arguments
            try process.run()
        #endif
        process.waitUntilExit()
        guard process.terminationStatus == .zero, let output = process.standardOutput as? String else {
            exit(1)
        }
        print(output)

        exit(0)
    }
}
