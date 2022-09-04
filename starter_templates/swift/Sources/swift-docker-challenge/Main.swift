import Foundation

@main
struct Main {

    // Usage: your_docker.sh run <image> <command> <arg1> <arg2> ...
    static func main() async throws {
        // You can use print statements as follows for debugging, they'll be visible when running tests.
        print("Logs from your program will appear here!")

        // Uncomment this block to pass the first stage!
        // let command = CommandLine.arguments[3]
        // let arguments = CommandLine.arguments.dropFirst(4).map { String($0) }
        // let process = Process()
        // process.executableURL = URL(fileURLWithPath: command)
        // process.arguments = arguments
        // try process.run()
        // process.waitUntilExit()
        // guard process.terminationStatus == .zero, let output = process.standardOutput as? String else {
        //     exit(1)
        // }
        // print(output)

        exit(0)
    }
}
