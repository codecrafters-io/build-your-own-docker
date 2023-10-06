import com.google.gson.Gson;
import lombok.SneakyThrows;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Map;

public class DockerClient {

  private static final Gson gson = new Gson();
  private static final HttpClient httpClient =
      HttpClient.newBuilder()
          .followRedirects(HttpClient.Redirect.NORMAL)
          .build();

  String token;
  String imageName;
  String imageTag;

  public void pullContainerImage(String tempDirPath) throws IOException {

    ImageIndex imageIndex = imageIndexFile();

    if (imageIndex.getSchemaVersion() == 1) {
      for (FSLayer layer : imageIndex.getFsLayers()) {
        pullAndExtractLayer(tempDirPath, layer.getBlobSum(), "");
      }
    } else if (imageIndex.getSchemaVersion() == 2) {

      V2DigestManifest manifest = digestManifestFile(imageIndex.getManifests().get(0).getDigest(), imageIndex.getManifests().get(0).getMediaType());

      for (Layer layer : manifest.getLayers()) {
        pullAndExtractLayer(tempDirPath, layer.getDigest(), layer.getMediaType());
      }
    }
  }

  @SneakyThrows
  public String authToken() throws IOException {
    HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create("https://auth.docker.io/token?service=registry.docker.io&scope=repository:" + imageName + ":pull"))
        .GET().build();

    HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

    Map<String, Object> result = gson.fromJson(response.body(), Map.class);

    return (String) result.get("token");
  }

  @SneakyThrows
  public ImageIndex imageIndexFile() throws IOException {
    HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create("https://registry.hub.docker.com/v2/" + imageName + "/manifests/" + imageTag))
        .header("Accept", "application/vnd.oci.image.index.v1+json")
        .header("Authorization", "Bearer " + token)
        .GET().build();

    HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

    ImageIndex result = gson.fromJson(response.body(), ImageIndex.class);

    return result;
  }

  @SneakyThrows
  public V2DigestManifest digestManifestFile(String digest, String mediaType) throws IOException {

    HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create("https://registry.hub.docker.com/v2/" + imageName + "/manifests/" + digest))
        .header("Accept", mediaType)
        .header("Authorization", "Bearer " + token)
        .GET().build();

    HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

    V2DigestManifest result = gson.fromJson(response.body(), V2DigestManifest.class);

    return result;
  }

  @SneakyThrows
  public void pullAndExtractLayer(String tempDirPath, String layerDigest, String mediaType) throws IOException {

    HttpRequest request = HttpRequest.newBuilder().uri(URI.create("https://registry.hub.docker.com/v2/" + imageName + "/blobs/" + layerDigest)).header("Accept", mediaType).header("Authorization", "Bearer " + token).GET().build();

    HttpResponse<byte[]> response = httpClient.send(request, HttpResponse.BodyHandlers.ofByteArray());

    byte[] layerData = response.body();

    String fileName = layerDigest.split(":")[1] + ".tar.gz";

    Files.write(Paths.get(fileName), layerData);

    // extract file
    Process process = new ProcessBuilder("tar", "-xzf", fileName, "-C", tempDirPath).start();

    int exitCode = process.waitFor();

    if (exitCode != 0) {
      System.err.printf("tar -xzf Err: %d\n", exitCode);
      System.exit(1);
    }

  }

}
