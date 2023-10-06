import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
class ImageIndex {
  private List<Manifest> manifests;
  private List<FSLayer> fsLayers;
  private String mediaType;
  private int schemaVersion;
}

@Getter
@Setter
class FSLayer {
  private String blobSum;
}

@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Getter
@Setter
class Manifest extends Layer {
  private Platform platform;
}

@Getter
@Setter
class Platform {
  private String architecture;
  private String os;
  private String variant;
}

@Getter
@Setter
class V2DigestManifest {
  private Layer config;
  private List<Layer> layers;
  private String mediaType;
  private int schemaVersion;
}

@Getter
@Setter
class Layer {
  private String digest;
  private String mediaType;
  private int size;
}
