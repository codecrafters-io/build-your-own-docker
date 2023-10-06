import com.sun.jna.Library;
import com.sun.jna.Native;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;

// your_docker.sh run <image>       <command> <arg1> <arg2> ...
//                run ubuntu:latest /usr/local/bin/docker-explorer exit 1
//                run ubuntu:latest /usr/local/bin/docker-explorer ls /some_dir
//                run ubuntu:latest echo hey
public class Main {

  public interface LibC extends Library {
    // GO: <CLONE_NEWPID = 0x20000000 // New pid namespace>
    int CLONE_NEWPID_NAMESPACE_FLAG = 0x20000000;

    int chroot(String path); // Define the JNA interface for libc, which includes the chroot function

    int unshare(int flags);
  }


  public static void main(String[] args) {
    System.out.println(Arrays.toString(args));
    String imageName = args[1];
    String command = args[2];
    String[] commandWithArgs = Arrays.copyOfRange(args, 2, args.length);
    try {
      ProcessBuilder processBuilder = new ProcessBuilder(commandWithArgs);
      processBuilder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
      processBuilder.redirectError(ProcessBuilder.Redirect.INHERIT);

      Process process = processBuilder.start();

      int exitCode = process.waitFor();

      if (exitCode != 0) {
        System.err.printf("Err: %d\n", exitCode);
        System.exit(1);
      }
    } catch (IOException | InterruptedException e) {
      System.err.printf("Err: %s\n", e.getMessage());
      System.exit(1);
    }


}
