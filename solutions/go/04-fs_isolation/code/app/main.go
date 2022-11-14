package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"syscall"
)

// Usage: your_docker.sh run <image> <command> <arg1> <arg2> ...
func main() {
	command := os.Args[3]
	args := os.Args[4:len(os.Args)]

	chrootDir, err := ioutil.TempDir("", "")
	if err != nil {
		fmt.Printf("error creating chroot dir: %v", err)
		os.Exit(1)
	}

	if err = copyExecutableIntoDir(chrootDir, command); err != nil {
		fmt.Printf("error copying executable into chroot dir: %v", err)
		os.Exit(1)
	}

	// Create /dev/null so that cmd.Run() doesn't complain
	if err = createDevNull(chrootDir); err != nil {
		fmt.Printf("error creating /dev/null: %v", err)
		os.Exit(1)
	}

	if err = syscall.Chroot(chrootDir); err != nil {
		fmt.Printf("chroot err: %v", err)
		os.Exit(1)
	}

	cmd := exec.Command(command, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err = cmd.Run()
	if exitErr, ok := err.(*exec.ExitError); ok {
		os.Exit(exitErr.ExitCode()) // The program exited with a non-zero exit code
	} else if err != nil {
		fmt.Printf("Err: %v", err)
		os.Exit(1)
	}
}

func copyExecutableIntoDir(chrootDir string, executablePath string) error {
	executablePathInChrootDir := path.Join(chrootDir, executablePath)

	if err := os.MkdirAll(path.Dir(executablePathInChrootDir), 0750); err != nil {
		return err
	}

	return copyFile(executablePath, executablePathInChrootDir)
}

func copyFile(sourceFilePath, destinationFilePath string) error {
	sourceFileStat, err := os.Stat(sourceFilePath)
	if err != nil {
		return err
	}

	sourceFile, err := os.Open(sourceFilePath)
	if err != nil {
		return err
	}
	defer sourceFile.Close()

	destinationFile, err := os.OpenFile(destinationFilePath, os.O_RDWR|os.O_CREATE, sourceFileStat.Mode())
	if err != nil {
		return err
	}
	defer destinationFile.Close()

	_, err = io.Copy(destinationFile, sourceFile)
	return err
}

func createDevNull(chrootDir string) error {
	if err := os.MkdirAll(path.Join(chrootDir, "dev"), 0750); err != nil {
		return err
	}

	return ioutil.WriteFile(path.Join(chrootDir, "dev", "null"), []byte{}, 0644)
}
