import subprocess
import sys


def main():
    # You can use print statements as follows for debugging, they'll be visible when running tests.
    print("Logs from your program will appear here!")

    # Uncomment this block to pass the first stage
    #
    # command = sys.argv[3]
    # args = sys.argv[4:]
    #
    # completed_process = subprocess.run([command, *args], capture_output=True)
    # print(completed_process.stdout.decode("utf-8"))


if __name__ == "__main__":
    main()
