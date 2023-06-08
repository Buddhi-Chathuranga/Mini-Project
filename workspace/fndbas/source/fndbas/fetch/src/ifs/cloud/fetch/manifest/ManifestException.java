package ifs.cloud.fetch.manifest;

import ifs.cloud.fetch.FetchException;

public class ManifestException extends FetchException {

   public ManifestException(ArtifactManifest manifest, Throwable cause) {
      super(new StringBuilder().append("Invalid manifest format ").append(manifest.getManifestName()).toString(), cause);
   }

   private static final long serialVersionUID = 1L;

   public ManifestException(ArtifactManifest manifest, String tag) {
      super(new StringBuilder().append("Invalid manifest format ").append(manifest.getManifestName()).append(". <").append(tag).append("> was not found.").toString());
   }
   
   
}
